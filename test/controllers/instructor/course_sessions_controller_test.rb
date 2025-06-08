require "test_helper"

class Instructor::CourseSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instructor_course_sessions_index_url
    assert_response :success
  end

  test "should get new" do
    get instructor_course_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get instructor_course_sessions_create_url
    assert_response :success
  end

  test "should get edit" do
    get instructor_course_sessions_edit_url
    assert_response :success
  end

  test "should get update" do
    get instructor_course_sessions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get instructor_course_sessions_destroy_url
    assert_response :success
  end
end
