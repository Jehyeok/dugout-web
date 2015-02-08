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
		@user = User.create(
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

	# POST /users/signin
	def signin
		user = User.find_by_email(params[:email])
		# 없는 이메일
		if user.nil?
			render plain: "등록되지 않은 이메일 입니다"
			return
		end

		# 로그인 성공
		if user.password == params[:password]
			session[:email] = params[:email]
			render plain: "success"
		else
			render plain: "패스워드가 일치하지 않습니다"
		end
	end

	# POST /users/signup
	def signup
		user_same_email = User.find_by_email(params[:email])
		user_same_nick_name = User.find_by_nick_name(params[:nick_name])

		unless user_same_email.nil?
			render plain: "이용중인 이메일입니다"
			# render plain: "duplicate email"
			return
		end

		unless user_same_nick_name.nil?
			render plain: "이용중인 닉네임입니다"
			return
		end

		if user_same_email.nil? && user_same_nick_name.nil?
			@user = User.create(
				email: params[:email],
				password: params[:password],
				nick_name: params[:nick_name],
				ip: request.remote_ip,
				favorite_group_number: 0
			)

			if @user.save
				render plain: "success"
			else
				render plain: "가입에 실패했습니다"
			end
		end
	end
end