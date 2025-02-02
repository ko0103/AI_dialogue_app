class CreateScores < ActiveRecord::Migration[7.2]
  def change
    create_table :scores do |t|
      t.references :chat_session, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
