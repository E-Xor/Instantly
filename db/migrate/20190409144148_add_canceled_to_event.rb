class AddCanceledToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :canceled, :boolean
  end
end
