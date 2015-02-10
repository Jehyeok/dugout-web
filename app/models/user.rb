class User < ActiveRecord::Base
	has_many :boards
	has_many :comments

	belongs_to :group

	validates :email, presence: true, uniqueness: true
	validates :nick_name, presence: true, uniqueness: true
end
