Test::Unit::TestCase.class_eval do
  include FactoriesAndWorkers::Factory
  
  factory :monkey, {
    :name      => "George",
    :unique  => "$UNIQ(10)",
    # :unique    => lambda{ uniq(10) },
    :counter => "$COUNT",
    # :counter   => lambda{ increment!(:monkey).to_s },
    :number    => lambda{ increment! :foo }
  }

  factory :pirate, {
    :catchphrase => "Ahhrrrr, Matey!",
    :monkey      => :belongs_to_model,
    :created_on  => lambda{ 1.day.ago }
  }

end
