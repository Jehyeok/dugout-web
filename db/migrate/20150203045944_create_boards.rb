class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
			t.integer :like, :default => 0
			t.integer :dislike, :default => 0
    	t.integer :count, :default => 0
    	t.string :title, :null => false
    	t.text :content, :null => false
    	t.integer :user_like_ids, :array => true, default: []
      t.integer :user_dislike_ids, :array => true, default: []
      # 0: 일반글 ( default )
      # 1: 공지글
      t.integer :level, :default => 0
      t.string :image_names, array: true, default: []

    	t.belongs_to :user, index: true, :null => false
      t.belongs_to :group, index: true, :null => false

      t.timestamps
    end
  end
end
