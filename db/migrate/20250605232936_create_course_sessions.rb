class CreateCourseSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :course_sessions do |t|
      t.references :course, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
