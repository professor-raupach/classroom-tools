require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post courses_url, params: { course: { course_number: @course.course_number, end_date: @course.end_date, end_time: @course.end_time, friday: @course.friday, instructor_id: @course.instructor_id, monday: @course.monday, saturday: @course.saturday, semester: @course.semester, start_date: @course.start_date, start_time: @course.start_time, sunday: @course.sunday, thursday: @course.thursday, title: @course.title, tuesday: @course.tuesday, wednesday: @course.wednesday, year: @course.year } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { course_number: @course.course_number, end_date: @course.end_date, end_time: @course.end_time, friday: @course.friday, instructor_id: @course.instructor_id, monday: @course.monday, saturday: @course.saturday, semester: @course.semester, start_date: @course.start_date, start_time: @course.start_time, sunday: @course.sunday, thursday: @course.thursday, title: @course.title, tuesday: @course.tuesday, wednesday: @course.wednesday, year: @course.year } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end
end
