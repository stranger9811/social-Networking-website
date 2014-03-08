class CreatePagesLikes < ActiveRecord::Migration
  def change
    create_table :pages_likes do |t|
        t.integer :user_id
        t.integer :page_id
      t.timestamps
    end
  end
end
