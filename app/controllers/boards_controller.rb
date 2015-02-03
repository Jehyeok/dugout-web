class BoardsController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /boards
	def index
		@boards = Board.all
		
		# respond_to do |format|
			# format.html
			# format.json { render json: @boards }
		# end
		render json: @boards
	end

	# GET /boards/new
	def new
	end

	# POST /boards
	def create
		@board = Board.create(
			title: params[:title],
			content: params[:content],
			group_number: params[:group_number].to_i,
			# user_id: params[:user_id]
			user_id: 1
		)

		puts "board: #{@board.inspect}"
		if @board.save
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# DELETE /boards/:id
	def destroy

	end
end
