class AddTutorToCourses < ActiveRecord::Migration[8.0]
  def change
    add_reference :courses, :tutor, foreign_key: { to_table: :users }, null: true
  end
end
