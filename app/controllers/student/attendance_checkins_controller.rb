module Student
  class AttendanceCheckinsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_course_session, only: [:new]

    def new
      if @course_session.attendance_closed?
        redirect_to root_path, alert: "Attendance for this session is closed."
        return
      end

      @already_checked_in = Attendance.exists?(user: current_user, course_session: @course_session)
    end

    def create
      @course_session = CourseSession.find(params[:course_session_id])
      if @course_session.attendance_closed?
        redirect_to root_path, alert: "Attendance is already closed."
        return
      end

      existing = Attendance.find_by(user: current_user, course_session: @course_session)

      if existing
        redirect_to student_attendance_checkin_path(@course_session), notice: "You've already checked in."
        return
      end

      @attendance = Attendance.create!(
        user: current_user,
        course_session: @course_session,
        timestamp: Time.current,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        cookie_token: cookies.signed[:checkin_secret]
      )

      redirect_to student_attendance_checkin_path(@attendance)
    end

    def show
      @attendance = Attendance.find(params[:id])
      @course_session = @attendance.course_session
      @course = @course_session.course
      @total_sessions = @course.course_sessions.count

      @attended_sessions = current_user.attendances
                                      .joins(:course_session)
                                      .where(course_sessions: { course_id: @course_session.course_id })
                                      .count

      @attendance_percent = if @total_sessions > 0
                              ((@attended_sessions.to_f / @total_sessions) * 100).round(1)
                            else
                              0.0
                            end
    end

    private

    def set_course_session
      @course_session = CourseSession.find(params[:id])
    end
  end
end
