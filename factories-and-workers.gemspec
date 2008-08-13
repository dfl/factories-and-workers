--- !ruby/object:Gem::Specification 
name: factories-and-workers
version: !ruby/object:Gem::Version 
  version: 0.0.1
platform: ruby
authors: 
- Nathan Herald
- David Lowenfels
- Jonathan Barket
autorequire: 
bindir: bin
cert_chain: []

date: 2008-08-05 00:00:00 -06:00
default_executable: 
dependencies: []

description: Fixtures replacement
email:
executables: []

extensions: []

extra_rdoc_files: []

files: 
- README.rdoc
- CHANGELOG
- LICENSE
- init.rb
- Rakefile
- lib/factories-and-workers
- lib/factories-and-workers.rb
- lib/factories-and-workers/factory_builder.rb
- lib/factories-and-workers/factory_generator.rb
- lib/factories-and-workers/factory_worker.rb
- lib/tasks
- lib/tasks/generate_factories.rake
- rails
- rails/init.rb
- test/app
- test/app/models
- test/app/models/monkey.rb
- test/app/models/pirate.rb
- test/app/models/user.rb
- test/db
- test/db/schema.rb
- test/factories.rb
- test/factory_builder_test.rb
- test/factory_worker_test.rb
- test/test_helper.rb

has_rdoc: true
homepage: http://blog.internautdesign.com/2008/6/4/factories-and-workers-plugin
post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: 1.8.5
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubygems_version: 1.2.0
signing_key: 
specification_version: 2
summary: Fixtures replacement
test_files: []


