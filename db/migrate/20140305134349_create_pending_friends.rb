class CreatePendingFriends < ActiveRecord::Migration
  def change
    create_table :pending_friends do |t|
    	t.integer :user1
    	t.integer :user2
      t.timestamps
    end
  end
end
