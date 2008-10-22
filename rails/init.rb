require 'fileutils'

config.after_initialize do

  # if script_console_running = defined?(::IRB) && ::IRB.conf[:LOAD_MODULES] && ::IRB.conf[:LOAD_MODULES].include?('console_with_helpers')
  #   # mixin to Object if we are running in ./script/console
    obj = Object
  # else # otherwise just mix into Test::Unit to play it safe
  #   obj = Test::Unit::TestCase
  # end

  # mixin plugin
  obj.send :include, FactoriesAndWorkers::Factory
  obj.send :include, FactoriesAndWorkers::Worker
  
  # load factory and worker definition files if they exist
  %w(spec/factories.rb spec/factory_workers.rb test/factories.rb test/factory_workers.rb).each do |file|
    path = File.join(Dir.pwd, file)
    require path if File.exists?(path)
  end

  # mixin factory and worker definitions
  obj.send :include, ::TestFactories if defined?(TestFactories)
  obj.send :include, ::FactoryWorkers if defined?(FactoryWorkers)
end


