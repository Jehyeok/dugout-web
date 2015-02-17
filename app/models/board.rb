class Board < ActiveRecord::Base
	require 'rubygems'
	require 'json'

	has_many :comments
	belongs_to :user
	belongs_to :group

	def comment_size
		self.comments.size
	end

	def user_nick_name
		self.user.nick_name
	end

	def comments_and_user_nick_name
		self.comments.as_json(methods: :dd)
	end

	def ordered_comments
		ordered_comments = []
		ancestor_comments = self.comments.select { |comment| comment.parent_id.nil? }
		ancestor_comments.each do |comment|
			ordered_comments << comment.self_and_descendents
		end
		ordered_comments.flatten.as_json(:methods => :user_nick_name)
	end
end
