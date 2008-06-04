class Object
  def factory_worker(worker, &block)
    if block.nil?
      raise NoMethodError, "undefined method 'factory_worker' for #{inspect}"
    else
      FactoryWorker.new(worker, &block)
    end
  end
  
  def worker(worker_name)
    FactoryWorker.find_and_work(worker_name)
  end
end

class FactoryWorker
  @@workers = {}
  def initialize(worker, &block)
    case worker
    when Hash
      @parent = worker.values.first.to_s
      @worker = worker.keys.first.to_s
    when Symbol, String
      @worker = worker.to_s
    else
      raise "I don't know how to make a factory worker out of '#{worker.inspect}'"
    end
    
    @block = block
    
    @@workers[@worker] = self
  end
  
  def self.find_and_work(worker_name)
    if @@workers.include?(worker_name.to_s)
      @@workers[worker_name.to_s].work
    else
      raise "There is no factory worker named '#{worker_name.to_s}' available"
    end
  end
  
  def work
    self.class.find_and_work(@parent) unless @parent.nil?
    
    surface_errors { instance_eval(&@block) }
  end
  
  def surface_errors
    yield
  rescue Object => error
    puts 
    puts "There was an error working the factory worker '#{@worker}'", error.inspect
    puts 
    puts error.backtrace
    puts 
    exit!
  end
end