module Factory; end

class Object
  include Factory

  def factory( factory, default_attributes={} )
    FactoryBuilder.new( factory, default_attributes )
  end
  
  def returning(value)
    yield(value)
    value
  end

end

class FactoryBuilder
  def initialize( factory, default_attributes={} )
    case factory
    when Symbol, String
      # @factory = factory.to_s
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
    Factory.module_eval %Q{
      def create_#{factory}( attributes={} )
        returning obj = #{factory.to_s.classify}.create!( valid_#{factory}_attributes.merge( attributes ) ) do
          yield obj if block_given?
        end
      end
    }

    # make the build method
    Factory.module_eval %Q{
        def build_#{factory}( attributes={} )
          returning obj = #{factory.to_s.classify}.new( valid_#{factory}_attributes.merge( attributes ) ) do
            yield obj if block_given?
          end
        end
      }

  end #initialize

end