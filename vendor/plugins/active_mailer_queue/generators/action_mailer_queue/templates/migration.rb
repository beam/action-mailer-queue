class Create<%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>" do |t|
      t.column :id,                       :integer
      t.column :from,                     :string, :limit => 64
      t.column :to,                       :string, :limit => 64
      t.column :subject,                  :string, :limit => 64
      t.column :content,                  :longblob
      t.column :created_at,               :datetime
      t.column :updated_at,               :datetime
    end
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end
