require_relative 'view'

module Simpler
  class Controller

    AVAILABLE_TYPES = [ :html, :plain ]

    attr_reader :name

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @view = View.new(@request.env)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = @request.params

      send(action)
      write_response
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body
      headers = @view.render_headers
      status = @view.render_status

      set_status(status)
      set_headers(headers)
      @response.write(body)
    end

    def set_headers(headers)
      if headers.nil?
        @response['Content-Type'] = "text/html"
      else
        headers.each do |key, value|
          @response[key] = value
        end
      end
    end

    def set_status(status)
      if status.nil?
        @response.status = 200
      else
        @response.status = status
      end
    end

    def render_body
      @view.render(binding)
    end

    def render(options)
      render_type = options.select { |k, v| k if AVAILABLE_TYPES.include?(k) }.keys[0]
      template = options[render_type]
      status = options[:status]
      headers = options[:headers]
      @request.env['simpler.render_type'] = render_type
      @request.env['simpler.template'] = template
      @request.env['simpler.render_status'] = status
      @request.env['simpler.render_headers'] = headers
    end

    def params
      arr = @request.env['REQUEST_URI'].split('/').reject { |value| value.empty? }
      id = arr[1].split('?').first.to_i
      if id != nil
        @request.params.merge!({ id: id })
      end
    end
  end
end
