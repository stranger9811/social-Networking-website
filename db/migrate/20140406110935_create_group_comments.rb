class CreateGroupComments < ActiveRecord::Migration
  def change
    create_table :group_comments do |t|
    	t.integer	:post_id
            t.string	:comment
            t.integer   :added_by
      t.timestamps
    end
  end
end
