require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      ERB.new(template_by_type).result(binding)
    end

    def render_status
      @env['simpler.render_status']
    end

    def render_headers
      @env['simpler.render_headers']
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def render_type
      @env['simpler.render_type']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def template_by_type
      case render_type
      when :plain
        template
      else
        File.read(template_path)
      end
    end

  end
end
