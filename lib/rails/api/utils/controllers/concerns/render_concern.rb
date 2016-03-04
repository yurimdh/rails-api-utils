module Rails
  module API
    module Utils
      module Controllers
        module RenderConcern
          extend ActiveSupport::Concern

          included do
            def render_success(data, serializer: nil)
              serializer_key = if data.respond_to?(:to_ary)
                                 :each_serializer
                               else
                                 :serializer
                               end
              render_options = { json: data, root: false, status: :ok }
              render_options[serializer_key] = serializer

              render render_options
            end
          end
        end
      end
    end
  end
end
