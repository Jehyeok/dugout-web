class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :password
    	t.string :email
  		t.string :nick_name
	    t.string :ip
	    t.integer :favorite_group_number

      t.timestamps
    end
  end
end
