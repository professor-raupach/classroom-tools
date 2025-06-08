class AddNotesToCourseSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :course_sessions, :notes, :text
  end
end
