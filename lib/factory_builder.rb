require 'active_support/core_ext'  # for returning()
module Factory; end

class Object
  include Factory

  def factory( factory, default_attrs={} )
    FactoryBuilder.new( factory, default_attrs )
  end

end

class FactoryBuilder
  def initialize( factory, default_attrs={} )
    raise "I don't know how to build '#{factory.inspect}'" unless [ Symbol, String ].include?( factory.class )

    # make the valid attributes method      
    valid_attrs_method = :"valid_#{factory}_attributes"

    Factory.send :define_method, valid_attrs_method do
      returning default_attrs.dup do |evaluated_attrs|
        default_attrs.each_pair do |key, value|
          evaluated_attrs[key] = value.call if value.is_a?(Proc)
        end
      end
    end

    ar_klass = ActiveRecord.const_get( factory.to_s.classify )

    # make the create method
    Factory.send :define_method, :"create_#{factory}" do |*args|
      overridden_attrs = args.first || {} # default to empty hash if no args provided
      returning ar_klass.create!( self.send( valid_attrs_method ).merge( overridden_attrs ) ) do |obj|  # default to empty hash if no args provided
        yield obj if block_given?  # magic pen
      end
    end

    # make the build method
    Factory.send :define_method, :"build_#{factory}" do |*args|
      overridden_attrs = args.first || {} # default to empty hash if no args provided
      returning ar_klass.new( self.send( valid_attrs_method ).merge( overridden_attrs) ) do |obj|
        yield obj if block_given?  # magic pen
      end
    end

  end #initialize

end