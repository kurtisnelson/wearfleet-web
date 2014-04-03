class AddSocketUrlToFleet < ActiveRecord::Migration
  def change
    add_column :fleets, :socket_url, :string
  end
end
