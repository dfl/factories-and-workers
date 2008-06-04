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
    ar_klass = ActiveRecord.const_get( factory.to_s.classify )

    # make the valid attributes method      
    valid_attrs_method = :"valid_#{factory}_attributes"

    Factory.send :define_method, valid_attrs_method do |*args|
      case args.first
      when Symbol  # only fetch a single attribute
        returning default_attrs[ args.first ] do |value|
          value = value.call if value.is_a?( Proc )      # evaluate lambda if needed
        end
      when nil, Hash
        attrs = default_attrs.symbolize_keys
        overrides = args.first
        attrs.merge!( overrides.symbolize_keys ) if overrides  # override default values as needed
        attrs.each_pair do |key, value|
          if overrides && overrides.keys.include?(:"#{key}_id")
            attrs.delete(key) # if :#{model}_id is overridden, then remove :#{model} and don't evaluate the lambda block
          else
            attrs[key] = value.call if value.is_a?(Proc) # evaluate lambda if needed
          end
        end
      end       
    end
    
    # alias default_*_attributes to valid_*_attributes
    Factory.send :alias_method, valid_attrs_method.to_s.gsub('valid','default').to_sym, valid_attrs_method


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