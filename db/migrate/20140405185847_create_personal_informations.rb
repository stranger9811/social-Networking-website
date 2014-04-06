class CreatePersonalInformations < ActiveRecord::Migration
  def change
    create_table :personal_informations do |t|
        t.string    :gender
        t.string    :city
        t.string    :university
        t.string    :phone
        t.string    :birthday
        t.integer   :user_id
        
      t.timestamps
    end
  end
end
