class CreateWallPostLikes < ActiveRecord::Migration
  def change
    create_table :wall_post_likes do |t|
        t.integer :wall_post_id
        t.integer   :liked_by
      t.timestamps
    end
  end
end
