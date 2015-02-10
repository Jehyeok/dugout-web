class Board < ActiveRecord::Base
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
end
