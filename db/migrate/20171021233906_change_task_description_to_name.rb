class ChangeTaskDescriptionToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :tasks, :description, :name
  end
end
