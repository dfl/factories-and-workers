require 'fileutils'

config.after_initialize do
  %w(spec/factories.rb spec/factory_workers.rb test/factories.rb test/factory_workers.rb).each do |file|
    path = File.join(Dir.pwd, file)
    require path if File.exists?(path)
  end
end
