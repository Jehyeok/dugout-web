class BoardsController < ApplicationController
	require 'digest'

	skip_before_filter :verify_authenticity_token 

	# GET /groups/:group_id/boards
	# :group_id = group_number
	def index
		@boards = Group.find_by_number(params[:group_id]).boards.order(id: :desc)

		# respond_to do |format|
			# format.html
			# format.json { render json: @boards }
		# end
		# render json: @boards, include: :comments
		render json: @boards.to_json(:methods => [:comment_size, :user_nick_name])
	end

	# GET /groups/:group_id/boards/:offset
	def boards_from_offset
		offset = params[:offset]

		group_id = params[:group_id]

		@boards = Group.find_by_number(group_id).boards.limit(50).offset(offset.to_i * 50).order(id: :desc).select { |board| board.level == 0 }

		if offset == "0"
			notice_boards = Group.find_by_number(group_id).boards.select { |board| board.level == 1 }
			@boards = notice_boards + @boards
		end
		
		render json: @boards.to_json(:methods => [:comment_size, :user_nick_name])
	end

	# GET /boards/popular
	def popular
		@boards = Board.all.select { |board| board.like >= 100 }

		render json: @boards.to_json(:methods => [:comment_size, :user_nick_name])
	end

	# GET /boards/my
	def my
		user_email = session[:email]
		@boards = Board.all.order(id: :desc).select { |board| board.user.email == user_email }
		# @boards = @boards.order(id: :desc)
		# @boards = Board.all.select { |board| board.user.email == user_email }
		render json: @boards.to_json(:methods => [:comment_size, :user_nick_name])
	end

	# GET /groups/:group_id/boards/new
	def new
	end

	# POST /groups/:group_id/boards
	def create
		group = Group.find_by_number(params[:group_id])
		puts "email: #{session[:email]}"
		user = User.find_by_email(session[:email])
		level = params[:level].nil? ? 0 : 1

		if 1 == level
			if session[:admin_key] != ENV["ADMIN_KEY"]
				render plain: "관리자가 아닙니다"
				return
			end
		end

		@board = Board.create(
			title: params[:title],
			content: params[:content],
			group_id: group.id,
			# user_id: params[:user_id]
			user_id: user.id,
			level: level
			# user_id: 1
		)

		(0...10).each do |i|
			puts i
			unless params["#file#{i}"].nil?
				file_name = "#{Digest::SHA256.hexdigest((rand() * 1000000).to_s)}.jpg"

				file_obj = params["#file#{i}"].tempfile
				contents = File.read(file_obj)
				puts Rails.root.to_s
				File.write("#{Rails.root}/app/assets/data/#{file_name}", contents)
				# File.open("app/assets/data/#{file_name}", "w+") {|f| f.write(contents) }
				# File.write("app/assets/data/#{file_name}", params["#file#{i}"])

				@board.image_names << file_name
				@board.image_names_will_change!	

				puts "file write!"
			end
		end

		if @board.save
			render plain: "success"
		else
			render plain: "글쓰기 실패했습니다"
		end
	end

	def update
		group = Group.find_by_number(params[:group_id])
		user = User.find_by_email(session[:email])
		board_id = params[:boardId]
		@board = Board.find(board_id)

		if (user.email != @board.user.email)
			render plain: "내 글만 수정할 수 있습니다"
			return 
		end

		new_board = Board.new(
			title: params[:title],
			content: params[:content],
			group_id: group.id,
			# user_id: params[:user_id]
			user_id: user.id
		)

		(0...10).each do |i|
			puts i
			unless params["#file#{i}"].nil?
				file_name = "#{Digest::SHA256.hexdigest((rand() * 1000000).to_s)}.jpg"

				file_obj = params["#file#{i}"].tempfile
				contents = File.read(file_obj)
				File.write("app/assets/data/#{file_name}", contents)
				# File.write("app/assets/data/#{file_name}", params["#file#{i}"])

				new_board.image_names << file_name
				new_board.image_names_will_change!	

				puts "file write!"
			end
		end

		if @board.update(content: new_board.content, image_names: new_board.image_names)
			render plain: "success"
		else
			render plain: "글쓰기 실패했습니다"
		end		
	end

	# POST /boards/:id/comments
	def comments 
		@board = Board.find(params[:board_id])
		@user = User.find_by_email(session[:email])
		parent_comment = params[:comment_parent_id].empty? ? nil : Comment.find(params[:comment_parent_id])

		@comment = Comment.create(
			content: params[:content],
			depth: parent_comment.nil? ? 0 : (parent_comment.depth + 1),
			board_id: params[:board_id],
			user_id: @user.id,
			parent_id: parent_comment.nil? ? nil : parent_comment.id
		)

		(0...10).each do |i|
			puts i
			unless params["#file#{i}"].nil?
				file_name = "#{Digest::SHA256.hexdigest((rand() * 1000000).to_s)}.jpg"
				
				file_obj = params["#file#{i}"].tempfile
				contents = File.read(file_obj)
				# File.write("app/assets/data/#{file_name}", contents)
				File.write("#{Rails.root}/app/assets/data/#{file_name}", contents)
				
				@comment.image_names << file_name
				@comment.image_names_will_change!
				puts "comment image file write!"
			end
		end

		@board.comments << @comment
		
		registration_id = @board.user.gcm_reg_id
		# registration_id = 	"APA91bFRdKfyvQrsGenpyoUNLE37YFv4EV6qYZL-jhiG6xaVXJ9r9egNRJVM8P81GmplDiPf5jFM_oEQP1y4PQs6ehN57vU07BL1vKnpip1VuHJBn48EsSuAnvFb9_cgd_YP6t-DbgqWOk99zf7LtUk-kV-RTLKG6g"

		if @board.save && @comment.save
			send_notification(registration_id, @board.id)

			render plain: "success"
		else
			render plain: "fail"
		end
	end

	def comment_update
		user = User.find_by_email(session[:email])
		@comment = Comment.find(params[:id])

		if (user.email != session[:email])
			render plain: "내 글만 수정할 수 있습니다"
			return 
		end

		new_comment = Comment.new(
			content: params[:content],
		)

		(0...10).each do |i|
			puts i
			unless params["#file#{i}"].nil?
				file_name = "#{Digest::SHA256.hexdigest((rand() * 1000000).to_s)}.jpg"
				
				file_obj = params["#file#{i}"].tempfile
				contents = File.read(file_obj)
				File.write("app/assets/data/#{file_name}", contents)
				
				new_comment.image_names << file_name
				new_comment.image_names_will_change!
				puts "comment image file write!"
			end
		end
		
		if @comment.update(content: new_comment.content, image_names: new_comment.image_names)
			render plain: "success"
		else
			render plain: "댓글달기 실패했습니다"
		end
	end

	# GET /groups/:group_id/boards/:id
	def show
		@board = Board.find(params[:id])
		@board.count += 1
		# render json: @board.to_json(:include => :comments, methods: [:comment_size, :user_nick_name])
		if @board.save
			# render json: @board.to_json(:include => {:comments => {:methods => [:user_nick_name]}}, :methods => [:comment_size, :user_nick_name])
			render json: @board.to_json(:methods => [:comment_size, :user_nick_name, :ordered_comments])
		else
			render plain: "fail"
		end
	end

	# POST /boards/:id/like
	def like
		@board = Board.find(params[:id])
		@board.like += 1
		user = User.find_by_email(session[:email])

		if @board.user_like_ids.include? user.id
			render plain: "이미 추천하셨습니다"
			return
		else
			@board.user_like_ids << user.id
			@board.user_like_ids_will_change!
		end
		
		if @board.save
			render plain: "success"
		else
			render palin: "추천하지 못했습니다"
		end
	end

	# POST /boards/:id/like
	def dislike
		@board = Board.find(params[:id])
		@board.dislike += 1
		user = User.find_by_email(session[:email])

		if @board.user_dislike_ids.include? user.id
			render plain: "이미 비추천하셨습니다"
			return
		else
			@board.user_dislike_ids << user.id
			@board.user_dislike_ids_will_change!
		end

		if @board.save
			render plain: "success"
		else
			render palin: "비추천하지 못했습니다"
		end
	end

	# DELETE /groups/:group_id/boards/:id
	def destroy
		user = User.find_by_email(session[:email])
		@board = Board.find(params[:id])

		if ((user.email != @board.user.email) && (!user.is_admin?))
			render plain: "내 글만 삭제할 수 있습니다"
			return 
		end

		if @board.destroy
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	def send_notification(registration_id, board_id)
		gcm = GCM.new("AIzaSyB_Cr3OyTcbmcNEJDMAFDab19pWlFuvSaM")
		# you can set option parameters in here
		#  - all options are pass to HTTParty method arguments
		#  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
		#  gcm = GCM.new("my_api_key", timeout: 3)

		registration_ids = [] # an array of one or more client registration IDs

		registration_ids.push(registration_id)

		options = {data: {content: "게시글에 댓글이 달렸습니다", board_id: board_id}, collapse_key: "demo"}
		response = gcm.send(registration_ids, options)
	end

	def noti_no_admin
		if session[:admin_key] != ENV["ADMIN_KEY"]
			render plain: "관리자가 아닙니다"
			return
		end
	end
end
