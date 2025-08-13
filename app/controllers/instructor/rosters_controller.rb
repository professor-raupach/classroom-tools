class Instructor::RostersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :authorize_instructor_for_course!

  def show
    load_roster_data
  end

  def csv
    load_roster_data
    require "csv"

    headers = ["Last Name", "First Name", "Email", "Student ID", "Attendance %"]

    data = CSV.generate(headers: true) do |out|
      out << headers
      @students.each do |s|
        out << [
          s.last_name,
          s.first_name,
          s.email,
          student_identifier(s),
          percent(@attended_by_user_id[s.id].to_i, @total_sessions)
        ]
      end
    end

    send_data data,
              filename: "roster-#{@course.id}-#{Time.zone.now.strftime('%Y%m%d')}.csv",
              type: "text/csv"
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  # Replace with your real permission logic if you have Pundit/CanCan
  def authorize_instructor_for_course!
    allowed =
      if @course.respond_to?(:instructor_id)
        @course.instructor_id == current_user.id
      else
        current_user.respond_to?(:instructor?) && current_user.instructor?
      end
    head :forbidden unless allowed || (current_user.respond_to?(:admin?) && current_user.admin?)
  end

  def load_roster_data
    # Sessions for denominator
    @sessions       = @course.course_sessions.order(:date)
    @total_sessions = @sessions.size

    # Students (uses enrolled_students if available; otherwise Enrollment → User)
    @students =
      if @course.respond_to?(:enrolled_students)
        @course.enrolled_students.order(:last_name, :first_name).to_a
      else
        User.joins(:enrollments).where(enrollments: { course_id: @course.id })
            .distinct.order(:last_name, :first_name).to_a
      end

    # Attendance counts per user (existence-based)
    if @total_sessions.positive? && @students.any?
      session_ids = @sessions.map(&:id)
      student_ids = @students.map(&:id)

      # Hash: { user_id => attended_count }
      @attended_by_user_id =
        Attendance.where(course_session_id: session_ids, user_id: student_ids)
                  .group(:user_id).count
    else
      @attended_by_user_id = Hash.new(0)
    end
  end

  # Display helper for “student id” if you have one; customize as needed.
  def student_identifier(user)
    if user.respond_to?(:student_id) && user.student_id.present?
      user.student_id
    elsif user.respond_to?(:username) && user.username.present?
      user.username
    else
      ""
    end
  end

  def percent(numer, denom)
    return "0%" if denom.to_i <= 0
    "#{((numer.to_f / denom) * 100).round}%"
  end
end
