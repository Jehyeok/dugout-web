class AdminController < ApplicationController
	def main

	end

	def users
		@users = User.all.order(id: :desc)
	end

	def user_boards
		@boards = User.find(params[:id]).boards.order(id: :desc)

		render "boards"
	end

	def boards
		@boards = Board.all.order(id: :desc);
	end
end
