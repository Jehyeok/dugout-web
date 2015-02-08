class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
    	# 0 = bears
			# 1 = eagles
			# 2 = tigers
			# 3 = kt
			# 4 = giants
			# 5 = lgtwins
			# 6 = nc
			# 7 = heros
			# 8 = lions
			# 9 = w
    	t.integer :number, :null => false
    	t.string :name, :null => false
    	t.integer :rank, :null => false

      t.timestamps
    end
  end
end
