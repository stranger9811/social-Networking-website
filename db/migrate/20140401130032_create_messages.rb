class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
        t.integer :user_from
        t.integer :user_to
        t.text :content
        t.string :status
      t.timestamps
    end
  end
end
