class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.text :content, :null => false
    	# 대댓글 깊이 설정
    	t.integer :depth, :default => 0
    	t.integer :user_id, :null => false
    	t.integer :board_id, :null => false
      t.integer :parent_id
      t.string :image_names, array: true, default: []
      
      t.timestamps
    end
  end
end
