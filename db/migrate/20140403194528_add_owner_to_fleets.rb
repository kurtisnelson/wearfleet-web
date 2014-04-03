class AddOwnerToFleets < ActiveRecord::Migration
  def change
    add_reference :fleets, :owner, index: true
  end
end
