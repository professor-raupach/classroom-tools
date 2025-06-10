require "test_helper"

class Instructor::AttendanceCheckinsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get instructor_attendance_checkins_show_url
    assert_response :success
  end

  test "should get create" do
    get instructor_attendance_checkins_create_url
    assert_response :success
  end

  test "should get end" do
    get instructor_attendance_checkins_end_url
    assert_response :success
  end
end
