class ActionMailerQueueGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      m.template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      m.directory File.join('app/views', class_path, "#{file_name}")
      m.migration_template 'create_migration.rb', 'db/migrate', { :migration_file_name => "create_#{file_name}" } 
    end
  end
  
end