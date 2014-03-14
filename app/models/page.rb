class Page < ActiveRecord::Base
    has_attached_file :profile_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
    validates_attachment_content_type :profile_pic, :content_type => /\Aimage\/.*\Z/
    has_attached_file :timeline_pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
    validates_attachment_content_type :timeline_pic, :content_type => /\Aimage\/.*\Z/
end
