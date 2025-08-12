module AttendanceReportsHelper
  # Returns the correct Attendance Report path for a course based on role
  def attendance_report_path_for(course)
    if current_user.respond_to?(:admin?) && current_user.admin?
      attendance_report_admin_course_path(course)
    else
      attendance_report_instructor_course_path(course)
    end
  end

  def attendance_report_csv_path_for(course)
    if current_user.respond_to?(:admin?) && current_user.admin?
      attendance_report_csv_admin_course_path(course)
    else
      attendance_report_csv_instructor_course_path(course)
    end
  end
end
