require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Course number", with: @course.course_number
    fill_in "End date", with: @course.end_date
    fill_in "End time", with: @course.end_time
    check "Friday" if @course.friday
    fill_in "Instructor", with: @course.instructor_id
    check "Monday" if @course.monday
    check "Saturday" if @course.saturday
    fill_in "Semester", with: @course.semester
    fill_in "Start date", with: @course.start_date
    fill_in "Start time", with: @course.start_time
    check "Sunday" if @course.sunday
    check "Thursday" if @course.thursday
    fill_in "Title", with: @course.title
    check "Tuesday" if @course.tuesday
    check "Wednesday" if @course.wednesday
    fill_in "Year", with: @course.year
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Course number", with: @course.course_number
    fill_in "End date", with: @course.end_date
    fill_in "End time", with: @course.end_time.to_s
    check "Friday" if @course.friday
    fill_in "Instructor", with: @course.instructor_id
    check "Monday" if @course.monday
    check "Saturday" if @course.saturday
    fill_in "Semester", with: @course.semester
    fill_in "Start date", with: @course.start_date
    fill_in "Start time", with: @course.start_time.to_s
    check "Sunday" if @course.sunday
    check "Thursday" if @course.thursday
    fill_in "Title", with: @course.title
    check "Tuesday" if @course.tuesday
    check "Wednesday" if @course.wednesday
    fill_in "Year", with: @course.year
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    click_on "Destroy this course", match: :first

    assert_text "Course was successfully destroyed"
  end
end
