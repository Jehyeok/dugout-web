class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :board

	has_many :children, :class_name => "Comment", :foreign_key => "parent_id"
	belongs_to :parent, :class_name => "Comment"
	
	scope :top_level, where(:parent_id => nil)

  has_many :comments

  def ancestor
    if self.depth == 0
      return self
    else
      self.parent.ancestor
    end
  end

	def descendents
    children.map do |child|
      [child] + child.descendents
    end.flatten
  end

  def self_and_descendents
    [self] + descendents
  end

  def size
    self.size
  end

  def user_nick_name
    self.user.nick_name
  end

  def comments
    self.self_and_descendents
  end
  # def descendents_users
  #   children.map do |child|
  #     [child.users] + child.descendents_users
  #   end.flatten
  # end
end
