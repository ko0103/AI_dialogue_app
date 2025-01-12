class CreateAiResponses < ActiveRecord::Migration[7.2]
  def change
    create_table :ai_responses do |t|
      t.references :message, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
