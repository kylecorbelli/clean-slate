class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :description
      t.boolean :is_done, default: false
      t.references :list, foreign_key: true

      t.timestamps
    end
  end
end
