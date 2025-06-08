class ChangeStartAndEndTimeToTimeInCourses < ActiveRecord::Migration[8.0]
  def change
    change_column :courses, :start_time, :time
    change_column :courses, :end_time, :time
  end
end
