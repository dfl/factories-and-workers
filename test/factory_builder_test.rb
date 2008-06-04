require File.expand_path(File.dirname(__FILE__) + "/_helper")

class FactoryBuilderTest < Test::Unit::TestCase
  # include ValidAttributes
  factory :monkey, {
    :name => "George"
  }

  factory :pirate, {
    :catchphrase => "Ahhrrrr, Matey!",
    :monkey      => lambda{ create_monkey }  
  }

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

  def test_lambda
    assert_difference "Pirate.count", 1 do
      assert_difference "Monkey.count", 1 do
        create_pirate
      end
    end
  end

  def test_overridden_attributes
    @phil = create_monkey( :name => "Phil" )
    assert_not_equal valid_monkey_attributes(:name), @phil.name

    assert_difference "Pirate.count", 0 do
      assert_difference "Monkey.count", 1 do
        @pirate = build_pirate( :monkey => @phil, :catchphrase => "chunky bacon!" )
      end
    end
    assert_not_equal valid_pirate_attributes(:catchphrase), @pirate.catchphrase    
    assert_equal "Phil", @pirate.monkey.name
    assert_equal "George", build_pirate.monkey.name
  end
  
  
end
