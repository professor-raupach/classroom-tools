require "test_helper"

class Instructor::HelpQueuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instructor_help_queues_index_url
    assert_response :success
  end

  test "should get show" do
    get instructor_help_queues_show_url
    assert_response :success
  end

  test "should get new" do
    get instructor_help_queues_new_url
    assert_response :success
  end

  test "should get create" do
    get instructor_help_queues_create_url
    assert_response :success
  end
end
