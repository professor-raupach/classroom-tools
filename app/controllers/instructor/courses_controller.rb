# app/controllers/instructor/courses_controller.rb
class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :ensure_instructor!
  helper CoursesHelper


  layout "application" # or a custom layout if needed

  def index
    @courses = current_user.instructed_courses
                           .includes(:instructor)
                           .order(Arel.sql("LOWER(course_number), LOWER(users.last_name), LOWER(users.first_name)"))
  end

  def show
    render template: "instructor/courses/show"
  end

  def create
    @course = Course.new(course_params)
    @course.instructor = current_user  # Ensures the instructor is correctly set

    if @course.save
      redirect_to instructor_courses_path, notice: "Course was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    render template: "instructor/courses/edit"
  end

  def update
    if @course.update(course_params)
      redirect_to instructor_course_path(@course), notice: "Course updated successfully."
    else
      render template: "instructor/courses/edit", status: :unprocessable_entity
    end
  end

  def new
    @course = current_user.instructed_courses.build
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to instructor_courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def start_attendance
    course = current_user.instructed_courses.find(params[:course_id])
    today = Date.current

    # Find or create the CourseSession for today
    session = course.course_sessions.find_or_create_by!(date: today)

    # Reopen attendance if it was previously ended
    if session.attendance_checkin_ended_at.present?
      session.update(attendance_checkin_ended_at: nil)
    end

    redirect_to instructor_course_course_session_attendance_checkin_path(course_id: course.id, course_session_id: session.id)
  end

  private

  def set_course
    @course = current_user.instructed_courses.find(params[:id])
  end

  def ensure_instructor!
    redirect_to root_path unless current_user.instructor?
  end

    def course_params
      params.require(:course).permit(
        :course_number, :title, :year, :semester, :start_date, :end_date,
        :start_time, :end_time,
        :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
      )
    end
end
