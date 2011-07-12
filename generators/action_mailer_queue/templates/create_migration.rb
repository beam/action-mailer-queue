class Create<%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>" do |t|
      t.column :id,                       :integer
      t.column :from,                     :string, :limit => 255, :default => nil
      t.column :to,                       :string, :limit => 255, :default => nil
      t.column :subject,                  :string, :limit => 255, :default => nil
      t.column :content,                  :longblob
      t.column :message_id,               :string, :limit => 255
      t.column :in_progress,              :boolean, :default => false, :null => false
      t.column :sent,                     :boolean, :default => false, :null => false
      t.column :attempts,                 :integer, :default => 0, :null => false
      t.column :last_error,               :string, :limit => 128, :default => nil
      t.column :priority,                 :integer, :default => 10, :null => false
      t.column :last_attempt_at,          :datetime, :default => nil
      t.column :sent_at,                  :datetime, :default => nil
      t.column :created_at,               :datetime, :default => nil
      t.column :updated_at,               :datetime, :default => nil
    end
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end
