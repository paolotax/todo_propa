class CreateAppuntoEvents < ActiveRecord::Migration
  def change
    create_table :appunto_events do |t|
      t.belongs_to :appunto
      t.string :state

      t.timestamps
    end

    add_index :appunto_events, :appunto_id
  end
end
