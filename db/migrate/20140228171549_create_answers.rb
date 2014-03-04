class CreateAnswers < ActiveRecord::Migration
    def change
        create_table :answers do |t|
            t.integer   :question_id
            t.text      :content
            t.integer   :added_by
            t.integer   :upvote
            t.integer   :downvote
            t.timestamps
        end
    end
end
