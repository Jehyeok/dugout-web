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

	# GET /boards/popular
	def popular
		@boards = Board.all.select { |board| board.like >= 100 }

		render json: @boards.to_json(:methods => [:comment_size, :user_nick_name])
	end

	# GET /boards/my
	def my
		user_email = session[:email]
		@boards = Board.all.select { |board| board.user.email == "jehyeok.hyun@gmail.com" }
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

		@board = Board.create(
			title: params[:title],
			content: params[:content],
			group_id: group.id,
			# user_id: params[:user_id]
			user_id: user.id
		)

		(0...10).each do |i|
			puts i
			unless params["#file#{i}"].nil?
				file_name = "#{Digest::SHA256.hexdigest((rand() * 1000000).to_s)}.png"
				File.write("app/assets/data/#{file_name}", params["#file#{i}"])
				@board.image_names << file_name
				@board.image_names_will_change!
				puts "file write!"
			end
		end

		if @board.save
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# POST /boards/:id/comments
	def comments 
		@board = Board.find(params[:id])
		@user = User.find_by_email(session[:email])
		parent_comment = params[:comment_parent_id].empty? ? nil : Comment.find(params[:comment_parent_id])

		@comment = Comment.create(
			content: params[:content],
			depth: parent_comment.nil? ? 0 : (parent_comment.depth + 1),
			board_id: params[:id],
			user_id: @user.id,
			parent_id: parent_comment.nil? ? nil : parent_comment.id
		)

		@board.comments << @comment

		if @board.save && @comment.save
			render plain: "success"
		else
			render plain: "fail"
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

	end
end
