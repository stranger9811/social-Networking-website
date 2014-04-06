class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
    	t.string	:content
    t.integer	:group_id
    t.integer	:user_id
      t.timestamps
    end
  end
end
