require 'active_support/core_ext'  # for returning()
module Factory; end

class Object
  include Factory

  def factory( factory, default_attributes={} )
    FactoryBuilder.new( factory, default_attributes )
  end

end

class FactoryBuilder
  def initialize( factory, default_attributes={} )
    case factory
    when Symbol, String
      factory = factory.to_s
    else
      raise "I don't know how to build '#{factory.inspect}'"
    end

    # make the valid attributes method      
    Factory.send :define_method, :"valid_#{factory}_attributes" do
      returning default_attributes.dup do |evaluated_attributes|
        default_attributes.each_pair do |key, value|
          evaluated_attributes[key] = value.call if value.is_a?(Proc)
        end
      end
    end

    # make the create method
    Factory.send :define_method, :"create_#{factory}" do |*args|
      ar_klass = ActiveRecord.const_get( factory.to_s.classify )
      valid_attrs = self.send(:"valid_#{factory}_attributes")
      returning obj = ar_klass.create!( valid_attrs.merge( args.first || {} ) ) do  # default to empty hash if no args provided
        yield obj if block_given?  # magic pen
      end
    end

    # make the build method
    Factory.send :define_method, :"build_#{factory}" do |*args|
      ar_klass = ActiveRecord.const_get( factory.to_s.classify )
      valid_attrs = self.send(:"valid_#{factory}_attributes")
      returning obj = ar_klass.new( valid_attrs.merge( args.first || {} ) ) do  # default to empty hash if no args provided
        yield obj if block_given?  # magic pen
      end
    end

  end #initialize

end