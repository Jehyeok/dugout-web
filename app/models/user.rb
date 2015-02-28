class User < ActiveRecord::Base
	has_many :boards, :dependent => :destroy
	has_many :comments, :dependent => :destroy

	belongs_to :group

	validates :email, presence: true, uniqueness: true
	validates :nick_name, presence: true, uniqueness: true
end
