require 'digest/sha1'

module FactoriesAndWorkers

  module Factory

    def self.included( base )
      base.extend ClassMethods
      base.class_eval do
        @@instance_counter = Hash.new(0)
      end
    end


    # create a random hex string, then convert it to hexatridecimal, and cut to length

    module ClassMethods
      def factory( kind, default_attrs={} )
        FactoryBuilder.new( kind, default_attrs )
      end

      def random_string len
        Digest::SHA1.hexdigest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}").to_i(16).to_s(36)[1..len.to_i]
      end

    end

    # factory methods are defined as class methods; this delegation will allow them to also be called as instance methods
    def method_missing method, *args
      if self.class.respond_to?( method )
        self.class.send method, *args
      else
        super
      end
    end

  end

  class FactoryBuilder
    def initialize( factory, default_attrs={} )
      ar_klass = ActiveRecord.const_get( factory.to_s.classify )

      # make the valid attributes method      
      valid_attrs_method = :"valid_#{factory}_attributes"

      Factory::ClassMethods.send :define_method, valid_attrs_method do |*args|
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
              attrs[key] = case value
              when Proc
                value.call  # evaluate lambda
              when :belongs_to_model  # create or build model, depending on calling context
                send "#{args[1] || :create }_#{key}"
              when String
                value.gsub( /\$UNIQUE\((\d+)\)/ ){ random_string( $1 ) }.
                      gsub( '$COUNTER', class_eval("@@instance_counter['#{key}'] += 1").to_s )
              else
                value
              end
            end
          end
        end       
      end

      # alias default_*_attributes to valid_*_attributes
      Factory::ClassMethods.send :alias_method, valid_attrs_method.to_s.gsub('valid','default').to_sym, valid_attrs_method


      # make the create method
      Factory::ClassMethods.send :define_method, :"create_#{factory}" do |*args|
        returning ar_klass.create!( self.send( valid_attrs_method, args.first, :create ) ) do |obj|
          yield obj if block_given?  # magic pen
        end
      end

      # make the build method
      Factory::ClassMethods.send :define_method, :"build_#{factory}" do |*args|
        returning ar_klass.new( self.send( valid_attrs_method, args.first, :build ) ) do |obj|
          yield obj if block_given?  # magic pen
        end
      end

    end #initialize
  end

end
