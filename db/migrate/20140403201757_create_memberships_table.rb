class CreateMembershipsTable < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :fleet, null: false
      t.belongs_to :user, null: false
      t.boolean :dispatcher, default: false
      t.boolean :admin, default: false
      t.boolean :approved, default: false
    end
  end
end
