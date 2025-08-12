# at the top of the file
require "set"

module AttendanceReportCommon
  extend ActiveSupport::Concern

  included do
    helper_method :percent, :present_for?
  end

  def show
    load_report_data
    render "attendance_reports/show"
  end

  def csv
    load_report_data

    require "csv"
    headers = ["Student"] + @sessions.map { |s| s.date.to_s } + ["Total", "Percent"]

    csv_string = CSV.generate(headers: true) do |out|
      out << headers
      @students.each do |stu|
        present_count = 0
        cells = @sessions.map do |sess|
          present = present_for?(stu.id, sess.id)
          present_count += 1 if present
          present ? "1" : "0"
        end
        out << ["#{stu.last_name}, #{stu.first_name}"] + cells + [present_count, percent(present_count, @sessions.size)]
      end

      session_counts   = @sessions.map { |s| @present_by_session_id[s.id] || 0 }
      overall_present  = session_counts.sum
      overall_possible = @students.size * @sessions.size
      out << ["Totals"] + session_counts.map(&:to_s) + [overall_present, percent(overall_present, overall_possible)]
    end

    send_data csv_string,
              filename: "attendance-#{@course.id}-#{Time.zone.now.strftime('%Y%m%d')}.csv",
              type: "text/csv"
  end

  private

  def load_report_data
    @sessions = @course.course_sessions.order(:date).to_a

    @students =
      if @course.respond_to?(:enrolled_students)
        @course.enrolled_students.order(:last_name, :first_name).to_a
      else
        User.joins(:enrollments).where(enrollments: { course_id: @course.id })
            .distinct.order(:last_name, :first_name).to_a
      end

    # Build a Set of [user_id, course_session_id] pairs for O(1) lookups.
    @presence_index = Set.new
    if @sessions.any? && @students.any?
      session_ids = @sessions.map(&:id)
      student_ids = @students.map(&:id)

      Attendance.where(course_session_id: session_ids, user_id: student_ids)
                .pluck(:user_id, :course_session_id)
                .each { |u, s| @presence_index << [u, s] }

      # Per-session present counts for the totals row
      @present_by_session_id =
        Attendance.where(course_session_id: session_ids, user_id: student_ids)
                  .group(:course_session_id).count
    else
      @present_by_session_id = {}
    end
  end

  # true if an Attendance record exists for the pair
  def present_for?(user_id, session_id)
    @presence_index.include?([user_id, session_id])
  end

  def percent(numer, denom)
    return "0%" if denom.to_i <= 0
    "#{((numer.to_f / denom) * 100).round}%"
  end
end
