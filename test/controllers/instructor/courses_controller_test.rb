require "test_helper"

class Instructor::CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instructor_courses_index_url
    assert_response :success
  end

  test "should get show" do
    get instructor_courses_show_url
    assert_response :success
  end

  test "should get edit" do
    get instructor_courses_edit_url
    assert_response :success
  end

  test "should get update" do
    get instructor_courses_update_url
    assert_response :success
  end
end
