require File.expand_path(File.dirname(__FILE__) + "/_helper")

class FactoryWorkerTest < Test::Unit::TestCase
  include FactoriesAndWorkers::Worker
  
  factory_worker :foo do
    @@foo = "bar!"
  end

  def test_worker
    worker :foo
    assert_equal "bar!", @@foo
  end

end
