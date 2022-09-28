require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    status, headers, body = @app.call(env)
    controller = env['simpler.controller']
    action = env['simpler.action']
    content_type = headers['Content-Type']
    @logger.info("Handler: #{controller.class}##{action}")
    @logger.info("Parameters: #{env['simpler.params']}")
    @logger.info("Response: #{status} [#{content_type}] #{controller.name}/#{action}.html.erb")
  end

end
