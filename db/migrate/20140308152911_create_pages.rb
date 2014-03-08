class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
        t.string :title
        t.text      :description
        t.integer   :likes
        t.string    :privacy
        t.integer   :admin_id
      t.timestamps
    end
  end
end
