class Group < ActiveRecord::Base
	has_many :boards
	has_many :users
end
