require 'test_helper'

class QuestionControllerTest < ActionController::TestCase
  test "should get ask" do
    get :ask
    assert_response :success
  end

end
