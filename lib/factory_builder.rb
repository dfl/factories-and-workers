require 'active_support/core_ext'  # for returning()
module Factory;end

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

    Factory.send :define_method, valid_attrs_method do |*args|
      case args.first
      when Symbol  # only fetch a single attribute
        value = default_attrs[ args.first ]
        value = value.call if value.is_a?( Proc ) #evaluate lambda if needed
      when nil, Hash
        attrs = default_attrs.symbolize_keys
        overrides = args.first
        attrs.merge!( overrides.symbolize_keys ) if overrides  # override default values if needed
        attrs.each_pair do |key, value|
          attrs[key] = value.call if value.is_a?(Proc) # evaluate lambda if needed
        end
      end       
    end

    ar_klass = ActiveRecord.const_get( factory.to_s.classify )

    # make the create method
    Factory.send :define_method, :"create_#{factory}" do |*args|
      returning ar_klass.create!( self.send( valid_attrs_method, *args ) ) do |obj|
        yield obj if block_given?  # magic pen
      end
    end

    # make the build method
    Factory.send :define_method, :"build_#{factory}" do |*args|
      returning ar_klass.new( self.send( valid_attrs_method, *args ) ) do |obj|
        yield obj if block_given?  # magic pen
      end
    end

  end #initialize

end