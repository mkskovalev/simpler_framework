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
      when :html
        File.read(template_path)
      when :plain
        template
      end
    end

  end
end
