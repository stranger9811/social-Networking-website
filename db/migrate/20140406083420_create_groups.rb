class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :privacy
      t.integer :admin_id

      t.timestamps
    end
  end
end
