class AddAttendanceCheckinEndedAtToCourseSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :course_sessions, :attendance_checkin_ended_at, :datetime
  end
end
