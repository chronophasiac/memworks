class CreateCardSubmissionLogs < ActiveRecord::Migration
  def change
    create_table :card_submission_logs do |t|
      t.boolean     :correct,             null: false, default: false
      t.integer     :rated_difficulty
      t.integer     :time_taken,          null: false
      t.integer     :card_submission_id,  null: false
      t.foreign_key :card_submissions

      t.timestamps
    end
    add_index :card_submission_logs, :card_submission_id
  end
end
