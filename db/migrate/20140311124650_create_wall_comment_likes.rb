class CreateWallCommentLikes < ActiveRecord::Migration
  def change
    create_table :wall_comment_likes do |t|
        t.integer :wall_comment_id
        t.integer   :liked_by
      t.timestamps
    end
  end
end
