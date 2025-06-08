require "test_helper"

class Student::HelpRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get student_help_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get student_help_requests_create_url
    assert_response :success
  end

  test "should get destroy" do
    get student_help_requests_destroy_url
    assert_response :success
  end
end
