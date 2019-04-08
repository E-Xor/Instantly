class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string   :uuid, null: false
      t.datetime :start_time
      t.datetime :end_time
      t.string   :invitee_email
      t.string   :invitee_name
      t.string   :invitee_event_name
      t.text     :all_attributes

      t.timestamps
    end
  end
end
