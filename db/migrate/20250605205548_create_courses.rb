class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :course_number
      t.string :title
      t.references :instructor, null: false, foreign_key: { to_table: :users }
      t.integer :year
      t.string :semester
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps
    end
  end
end
