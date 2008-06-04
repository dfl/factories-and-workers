require File.expand_path(File.dirname(__FILE__) + "/_helper")

class FactoryBuilderTest < Test::Unit::TestCase
  def metaclass; class << self; self; end; end

  def test_unknown_factory_raises_error
    e = assert_raises(NameError) do
      metaclass.class_eval do
        factory :foo
      end
    end
    assert_equal "uninitialized constant ActiveRecord::Foo", e.message
  end


  def test_build_monkey
    assert_difference "Monkey.count", 0 do
      build_monkey
    end
  end 
   
  def test_create_monkey
    assert_difference "Monkey.count", 1 do
      create_monkey
    end
  end
  
  def test_valid_monkey_attributes
    assert_equal( {:name => "George"}, valid_monkey_attributes )
  end
  
  def test_default_monkey_attributes_alias
    assert_equal valid_monkey_attributes, default_monkey_attributes
  end



  def test_build_pirate
    assert_difference "Pirate.count", 0 do
      assert_difference "Monkey.count", 0 do
        build_pirate
      end
    end
  end

  def test_valid_pirate_attributes_calling_lambda
    assert_difference "Monkey.count", 1 do
      assert_equal "Ahhrrrr, Matey!", valid_pirate_attributes[:catchphrase]
    end
  end
  
  def test_valid_pirate_attributes_with_single_arg_does_not_call_lambda
    assert_difference "Monkey.count", 0 do
      assert_equal "Ahhrrrr, Matey!", valid_pirate_attributes(:catchphrase)
    end
  end
      
  def test_create_pirate_evaluates_lambda
    assert_difference "Pirate.count", 1 do
      assert_difference "Monkey.count", 1 do
        @pirate = create_pirate
      end
    end
    assert_equal @pirate.created_on.to_s, 1.day.ago.to_s
    sleep 1
    assert_not_equal create_pirate.updated_on.to_s, @pirate.updated_on.to_s
  end
  
  def test_overridden_attributes
    @phil = create_monkey( :name => "Phil" )
    assert_not_equal valid_monkey_attributes[:name], @phil.name
    
    assert_difference "Pirate.count", 0 do
      assert_difference "Monkey.count", 0 do
        @pirate = build_pirate( :monkey => @phil, :catchphrase => "chunky bacon!" )
      end
    end
    assert_not_equal valid_pirate_attributes(:catchphrase), @pirate.catchphrase    
    assert_equal "Phil", @pirate.monkey.name
    assert_equal "George", build_pirate.monkey.name
  end
    
  def test_overridden_attribute_id_will_not_evaluate_lambda_for_model_creation
    assert_difference "Monkey.count", 0 do
      @pirate = build_pirate( :monkey_id => 1 )
    end    
  end

  
end
