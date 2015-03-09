class CommentsController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /comments
	def index
		@comments = Board.all
		
		# respond_to do |format|
			# format.html
			# format.json { render json: @boards }
		# end
		render json: @comments
	end

	# GET /boards/:id/comments
	def board_comments
		@board = Board.find(params[:id])
		
		ancestor_comments = @board.comments.select { |comment| comment.parent_id.nil? }
		@ordered_comments = []

		ancestor_comments.each do |comment|
			@ordered_comments << comment.self_and_descendents
		end
		
		render json: @ordered_comments.flatten.to_json(:method => [:is_me?])
	end

	# GET /comments/new
	def new
	end

	# POST /comments
	def create
		@comment = Comment.create(
			content: params[:content],
			depth: params[:depth].to_i,
			parent_id: params[:parent_id].to_i,
			# user_id: params[:user_id],
			# board_id: params[:board_id]
			# user_id: 1,
			# board_id: 1,
		)
		
		puts "comment: #{@comment.inspect}"
		if @comment.save
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# DELETE /comments/:id
	def destroy
		user = User.find_by_email(session[:email])
		@comment = Comment.find(params[:id])

		if ((user.email != @comment.user.email) && (!user.is_admin?))
			render plain: "내 댓글만 삭제할 수 있습니다"
			return 
		end

		if @comment.destroy
			render plain: "success"
		else
			render plain: "fail"
		end
	end
end
