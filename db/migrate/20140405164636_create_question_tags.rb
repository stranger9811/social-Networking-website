class CreateQuestionTags < ActiveRecord::Migration
  def change
    create_table :question_tags do |t|
        t.integer   :question_id
        t.string    :tag_name
      t.timestamps
    end
  end
end
