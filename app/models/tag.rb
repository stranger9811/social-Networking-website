class Tag < ActiveRecord::Base
	has_many  :question_tags,dependent: :destroy
	has_many 	:questions, :through => :question_tags,dependent: :destroy
end
