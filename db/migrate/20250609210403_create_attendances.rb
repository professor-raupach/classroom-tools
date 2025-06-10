class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_session, null: false, foreign_key: true
      t.datetime :timestamp, null: false
      t.string :ip_address
      t.text :user_agent
      t.string :cookie_token

      t.timestamps
    end
    add_index :attendances, [:user_id, :course_session_id], unique: true
  end
end
