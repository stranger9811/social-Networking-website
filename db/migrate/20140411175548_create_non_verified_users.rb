class CreateNonVerifiedUsers < ActiveRecord::Migration
  def change
    create_table :non_verified_users do |t|
        t.string    :fname
        t.string    :lname
        t.string    :email
        t.string    :passcode
        t.string    :password
      t.timestamps
    end
  end
end
