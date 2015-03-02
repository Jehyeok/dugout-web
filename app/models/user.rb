class User < ActiveRecord::Base
	has_many :boards, :dependent => :destroy
	has_many :comments, :dependent => :destroy

	belongs_to :group

	validates :email, presence: true, uniqueness: true
	validates :nick_name, presence: true, uniqueness: true

	def is_admin_email?
		return self.email == ENV["ADMIN_EMAIL"]
	end

	def is_admin?
		return ((self.is_admin_email?) && (session[:admin_key] == ENV["ADMIN_KEY"]))
	end
end