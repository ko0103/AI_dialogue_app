class CreateTasks < ActiveRecord::Migration[7.2]
    def change
      create_table :tasks do |t|
        t.string :name

        t.timestamps
      end
    end
end
