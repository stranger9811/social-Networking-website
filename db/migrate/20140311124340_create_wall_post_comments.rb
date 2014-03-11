class CreateWallPostComments < ActiveRecord::Migration
  def change
    create_table :wall_post_comments do |t|
        t.integer	:wall_post_id
        t.integer 	:likes
        t.string	:comment
        t.integer   :added_by
      t.timestamps
    end
  end
end
