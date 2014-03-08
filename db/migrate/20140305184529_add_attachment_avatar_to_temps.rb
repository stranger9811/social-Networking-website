class AddAttachmentAvatarToTemps < ActiveRecord::Migration
  def self.up
    change_table :temps do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :temps, :avatar
  end
end
