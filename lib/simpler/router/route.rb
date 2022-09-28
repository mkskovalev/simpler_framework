module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller  = controller
        @action = action
      end

      def match?(method, path)
        if @action == 'show'
          @method == method && @path == path_with_id(path)
        else
          @method == method && @path == path
        end
      end

      private

      def path_with_id(path)
        id = path.split('/').last
        path.sub! id, ':id'
      end
    end
  end
end
