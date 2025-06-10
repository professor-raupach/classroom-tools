class Instructor::AttendanceCheckinsController < ApplicationController
  def show
    @course = current_user.instructed_courses.find(params[:course_id])
    @course_session = @course.course_sessions.find(params[:course_session_id])

    # Redirect if the check-in has already ended
    if @course_session.attendance_checkin_ended_at.present?
      redirect_to instructor_course_path(@course), alert: "Attendance check-in for today has already ended."
      return
    end

    # Set default countdown duration (e.g., 5 minutes)
    @countdown_seconds = 5.minutes.to_i
  end


  def create
    @course = current_user.instructed_courses.find(params[:course_id])
    @course_session = @course.course_sessions.find(params[:course_session_id])

    @course_session.update!(attendance_checkin_ended_at: nil)

    redirect_to instructor_course_course_session_attendance_checkin_path(@course, @course_session), notice: "Attendance check-in reopened."
  end

  def end
    @course = current_user.instructed_courses.find(params[:course_id])
    @course_session = @course.course_sessions.find(params[:course_session_id])

    if @course_session
      @course_session.update!(attendance_checkin_ended_at: Time.current)
      redirect_to closed_instructor_course_course_session_attendance_checkin_path(@course, @course_session)
    else
      redirect_to instructor_courses_path, alert: "Course session not found."
    end
  end

  def closed
    @course = current_user.instructed_courses.find(params[:course_id])
    @course_session = @course.course_sessions.find(params[:course_session_id])
  end

end
