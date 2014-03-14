class AddImageToUser < ActiveRecord::Migration
  def change
      add_attachment :users, :profile_pic
      add_attachment :users, :timeline_pic
  end
end
