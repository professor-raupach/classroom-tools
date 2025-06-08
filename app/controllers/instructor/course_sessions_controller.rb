class Instructor::CourseSessionsController < ApplicationController
  before_action :set_course, only: %i[ index edit update new create]

  def index
    @course_sessions = @course.course_sessions.order(date: :desc)
  end

  def new
    @course_session = @course.course_sessions.new
  end

  def create
    @course_session = @course.course_sessions.new(course_session_params)
    if @course_session.save
      redirect_to instructor_course_course_sessions_path(@course), notice: "Session created."
    else
      render :new
    end
  end

  def destroy
    @help_request = HelpRequest.find(params[:id])
    @help_request.destroy

    respond_to do |format|
      if request.path.include?("instructor")
        format.html { redirect_to manage_instructor_help_queue_path(@help_request.help_queue), notice: "Student removed from the queue." }
      else
        format.html { redirect_to removed_student_help_requests_path, notice: "You have been removed from the queue." }
      end
    end
  end

  private

  def set_course
    @course = current_user.instructed_courses.find(params[:course_id])
  end

  def course_session_params
    params.require(:course_session).permit(:date, :notes)
  end
end
