class CreatePostComments < ActiveRecord::Migration
    def change
        create_table :post_comments do |t|
            t.integer	:post_id
            t.integer 	:likes
            t.string	:comment
            t.integer   :added_by
            
            t.timestamps
        end
    end
end
