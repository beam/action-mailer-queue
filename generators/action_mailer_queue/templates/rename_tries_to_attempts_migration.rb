class RenameTriesToAttemptsIn<%= class_name %> < ActiveRecord::Migration
  
  def self.up
    rename_column :<%= table_name %>, :tries, :attempts
  end
  
  def self.down
    rename_column :<%= table_name %>, :attempts, :tries
  end
  
end