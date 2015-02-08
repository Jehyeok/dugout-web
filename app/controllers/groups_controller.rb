class GroupsController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /boards
	def index
		@groups = Group.order(rank: :asc)
		
		# respond_to do |format|
			# format.html
			# format.json { render json: @boards }
		# end
		render json: @boards
	end
end
