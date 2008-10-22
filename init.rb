if defined?(RAILS_ENV) && __FILE__ =~ %r{vendor/plugins} # are we running as a rails plugin?

  # Modify the variable below to specify in which environments this plugin should be loaded.
  load_plugin_in = {
    'test'        => true,
    'development' => true,   # NOTE: often comes in handy in the console
    'production'  => false,
  }

  if load_plugin_in[ RAILS_ENV ]
    require "factories-and-workers"
    require File.dirname(__FILE__)+"/rails/init.rb"
  end


else  # bootstrap the gem

  require "factories-and-workers"
  require File.dirname(__FILE__)+"/rails/init.rb" if defined?(RAILS_ENV)

  # NOTE: if using as a gem with Rails and you want similar behaviour as above, do something like this in environment.rb :
  # config.after_initialize do
  #   config.gem 'dfl-factories-and-workers', :lib => 'factories-and-workers', :source => 'http://gems.github.com' unless RAILS_ENV=='production'
  # end

end  
