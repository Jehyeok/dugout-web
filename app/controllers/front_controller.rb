class FrontController < ApplicationController
	def index
		redirect_to boards_path
	end
end
