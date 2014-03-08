class CreatePagesPosts < ActiveRecord::Migration
  def change
    create_table :pages_posts do |t|
    t.string	:content
    t.integer	:likes
    t.integer	:page_id
    t.integer	:user_id
    
      t.timestamps
    end
  end
end
