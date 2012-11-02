class AddSeverityToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :severity, :string
  end
end
