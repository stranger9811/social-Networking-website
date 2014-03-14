class AddImageToPage < ActiveRecord::Migration
  def change
      add_attachment :pages, :profile_pic
      add_attachment :pages, :timeline_pic
  end
end
