class CreateCookieChecks < ActiveRecord::Migration
  def change
    create_table :cookie_checks do |t|
    	t.integer	:user_id
    	t.string	:checksum
      t.timestamps
    end
  end
end
