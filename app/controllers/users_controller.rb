class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token 

	# GET /users
	def index
		@users = User.all
		
		# respond_to do |format|
			# format.html
			# format.json { render json: @boards }
		# end
		render json: @users
	end

	# GET /users/new
	def new
	end

	# POST /users
	def create
		@user = user.create(
			email: params[:email],
			password: params[:password],
			nick_name: params[:nick_name],
			ip: request.remote_ip,
			favorite_group_number: 0
		)

		puts "user: #{@user.inspect}"
		if @user.save
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# DELETE /users/:id
	def destroy

	end
end
