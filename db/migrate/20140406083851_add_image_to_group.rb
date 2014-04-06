class AddImageToGroup < ActiveRecord::Migration
  def change
      add_attachment :groups, :timeline_pic
  end
end
