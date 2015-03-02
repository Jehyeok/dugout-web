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
			board_id: 0
		)

		puts "user: #{@user.inspect}"
		if @user.save
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# POST /users/change_nick_name
	def change_nick_name
		@user = User.find_by_email(session[:email])
		@user.nick_name = params[:will_nick_name]

		if @user.save
			render plain: "success"
		else
			render plain: "닉네임을 변경하지 못했습니다"
		end
	end

	# DELETE /users/:id
	def destroy
		my_user = User.find_by_email(session[:email])
		@user = User.find(params[:id])

		if !my_user.is_admin?
			render plain: "관리자가 아닙니다"
			return
		end

		if @user.destroy
			render plain: "success"
		else
			render plain: "fail"
		end
	end

	# POST /users/signin
	def signin
		user = User.find_by_email(params[:email])

		# 없는 이메일
		if user.nil?
			render plain: "등록되지 않은 이메일 입니다"
			return
		end

		if user.is_admin_email?
			puts "admin_email!"
			session[:admin_key] = ENV["ADMIN_KEY"]
		end

		# 로그인 성공
		if user.password == params[:password]
			puts "params email: params[:email]"
			session[:email] = params[:email]
			puts "session[:email]: #{session[:email]}"

			# gcm_reg_id 등록
			user.gcm_reg_id = params[:gcmRegId]
			user.save!

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
				group_id: 1
			)

			if @user.save
				render plain: "success"
			else
				render plain: "가입에 실패했습니다"
			end
		end
	end
end