class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.text :content
    	# 대댓글 깊이 설정
    	t.intger :depth, :default => 0
    	t.integer :user_id
    	t.integer :board_id

      t.timestamps
    end
  end
end
