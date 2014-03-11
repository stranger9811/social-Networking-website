class CreateWallPosts < ActiveRecord::Migration
  def change
    create_table :wall_posts do |t|
        t.string	:content
        t.integer	:likes
        t.integer	:from_id
        t.integer	:to_id
      t.timestamps
    end
  end
end
