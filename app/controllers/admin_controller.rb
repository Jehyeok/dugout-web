class AdminController < ApplicationController
	require 'gcm'

	def signin
		
	end

	def main
		check_amdin
	end

	def users
		check_amdin
		@users = User.all.order(id: :desc)
	end

	def user_boards
		check_amdin
		@boards = User.find(params[:id]).boards.order(id: :desc)

		render "admin/boards/index"
	end

	def boards
		check_amdin
		@boards = Board.all.order(id: :desc);

		render "admin/boards/index"
	end

	def board_new
		check_amdin
		render "admin/boards/new"
	end

	def set_rank_form
	end

	def set_rank
		(0...10).each do |i|
			group = Group.find_by_number(i)
			group.rank = params[i.to_s].to_i - 1
			group.save!
		end

		render plain: "success"
	end

	def check_amdin
		begin
			@user = User.find_by_email(session[:email])
			puts "유저있다"
			if !@user.is_admin?
				puts "관리자 아니다"
				redirect_to action: "signin"
				return
			end
		rescue
			# render "admin/signin"
			puts "에러다"
			redirect_to action: "signin"
			return
		end
	end
end
