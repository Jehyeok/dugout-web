class Group < ActiveRecord::Base
	has_many :boards, :dependent => :destroy
	has_many :users
end
