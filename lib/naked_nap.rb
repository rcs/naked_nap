require 'rack'
require 'multi_json'

class NakedNap
  # Define the class that NakedNap will wrap
  def initialize(target_class = nil, &block)
    if block_given?
      @target_obj = block
    else
      raise ArgumentError unless target_class.respond_to? :new
      @target_obj = lambda { target_class.new }
    end
  end

  # Interface for rack, called with the request environment
  def call(env)
    request = Rack::Request.new(env)

    # Set up the method and parameters to call
    target = @target_obj.call
    method, *args = extract_arguments(request)

    return [404, {'Content-Type' => 'text/plain'}, "No index defined"] unless method

    # Wrapped in a bre block to allow us to catch ruby level exceptions and turn them into HTTP codes
    begin
      body = MultiJson.encode(target.send(method,*args))
      #TODO: Log exceptions!
    rescue ArgumentError => e
      log "400"
      [400, {'Content-Type' => 'text/plain'}, e.to_s]
    rescue NoMethodError => e
      log "404"
      [404, {'Content-Type' => 'text/plain'}, "Method not found: #{e.name}"]
    rescue Exception => e
      log "500"
      log e
      [500, {'Content-Type' => 'text/plain'}, "Something went wrong."]
    else
      [200, {'Content-Type' => 'application/json'}, [body]]
    end
  end

  # Take a Rack::Request and turn it into a method name and ruby-style argument list
  def extract_arguments(req)
    method, *fixed = req.path_info.split('/').reject {|s| s.length == 0 }

    if req.params.length > 0 then
      fixed.push req.params
    end

    [method,*fixed]
  end

  # Helper method for my debugging
  def log(*stuff)
    $stderr.puts stuff
  end
end
