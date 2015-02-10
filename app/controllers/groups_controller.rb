class GroupsController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /groups
	def index
		@groups = Group.order(rank: :asc)
		# @groups = Group.order(rank: :desc)
		render json: @groups
	end

	# POST /users/select
	# param[:group_number]
	def select
		@group = Group.find_by_number(params[:group_number])
		# @user = User.find_by_email(session[:email])
		@user = User.find_by_email("jehyeok.hyun@gmail.com")

		@user.group = @group
		if @user.save
			render plain: "success" 
		else
			render plain: "팀 선택 실패"
		end
	end
end
