class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user
      t.belongs_to :fleet
      t.string :uuid
      t.timestamps
    end
  end
end
