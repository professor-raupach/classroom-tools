class CreateHelpQueues < ActiveRecord::Migration[8.0]
  def change
    create_table :help_queues do |t|
      t.references :course_session, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
