require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']

      changed_path = path_has_id?(path) ? path_with_id(path) : path

      @routes.find { |route| route.match?(method, changed_path) }
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]

      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def path_has_id?(path)
      path_to_array = path.split('/').reject { |value| value.empty? }
      path_to_array[1] != nil
    end

    def path_with_id(path)
      id = path.split('/').last
      path.sub! id, ':id'
    end
  end
end
