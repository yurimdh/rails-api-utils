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

            def render_created(data, serializer: nil)
              render(
                root: false,
                status: :created,
                json: data,
                serializer: serializer
              )
            end


            def render_error(message, status: :bad_request, errors: nil)
              data = {
                message: message
              }
              data[:errors] = Array(errors) unless errors.nil?

              render status: status, json: data
            end

            def render_not_found(message = "Resource not found.")
              render_error message, status: :not_found
            end
          end
        end
      end
    end
  end
end
