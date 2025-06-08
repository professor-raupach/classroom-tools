class CreateHelpRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :help_requests do |t|
      t.references :help_queue, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
