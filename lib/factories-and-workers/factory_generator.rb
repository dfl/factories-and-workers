module Factory

  def self.generate_template arg
    p model = arg.classify.constantize
    columns = {}
    model.columns.each do |col|
      key = col.name
      columns[ key.to_sym ] = case key
      when /^.+_id$/
        :belongs_to_model
      else
        { :type => col.type, :default => col.default }
      end unless IGNORED_COLUMNS.include?( key )
    end

    template = "\nfactory :#{model.to_s.underscore}, {\n"
    columns.each_pair do |name, val|
      template += "  :#{name} => #{ default_for( val ) },\n"
    end
    template += "}\n\n"
  end

  protected

  IGNORED_COLUMNS = %w[ id created_at updated_at created_on updated_on ]


  def self.default_for val
    case val
    when :belongs_to_model
      return val.inspect
    when Hash
      # return val[:default] if val[:default] # not sure if this works?
      case val[:type]
      when :integer
        123
      when :string
        "SomeString".inspect
      when :float
        1.23
      when :date
        "lambda{ Time.zone.today - 7 }"
      when :datetime
        "lambda{ Time.zone.now - 3600 }"
      end
    end
  end

end

# puts Factory.generate_template( "Project" )
# puts Factory.generate_template( "Task" )
