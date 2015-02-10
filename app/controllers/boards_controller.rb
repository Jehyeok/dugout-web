class BoardsController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /groups/:group_id/boards
	# :group_id = group_number
	def index
		@boards = Group.find_by_number(params[:group_id]).boards

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

		puts "board: #{@board.inspect}"
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
		parent_comment = params[:comment_parent_id].nil? ? nil : Comment.find(params[:comment_parent_id])

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
			render json: @board.to_json(:include => {:comments => {:methods => [:user_nick_name]}}, :methods => [:comment_size, :user_nick_name])
		else
			render plain: "fail"
		end
	end

	# DELETE /groups/:group_id/boards/:id
	def destroy

	end
end
