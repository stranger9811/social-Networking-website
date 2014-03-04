class CreateQuestions < ActiveRecord::Migration
    def change
        create_table :questions do |t|
            t.string  :title
            t.text    :content
            t.integer :added_by
            t.string  :privacy
            t.integer :upvote
            t.integer :downvote
            t.timestamps
        end
    end
end
