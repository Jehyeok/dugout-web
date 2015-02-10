class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :password, :null => false
    	t.string :email, :null => false
  		t.string :nick_name, :null => false
	    t.string :ip

      t.belongs_to :group, index: true, :null => false, default: 1

      t.timestamps
    end
  end
end
