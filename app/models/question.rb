class Question < ActiveRecord::Base
	has_many :answers, dependent: :destroy
	has_many :question_tags, dependent:	:destroy
end
