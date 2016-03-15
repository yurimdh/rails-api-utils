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

            def render_unauthorized(message = "Invalid credentials")
              render_error(message, status: :unauthorized)
            end

            def render_forbidden(message = "Not allowed")
              render_error(message, status: :forbidden)
            end

            def render_no_content
              head :no_content
            end

            # `_render_option_json` and `_render_with_renderer_json` are both
            # methods from ActiveModel::Serializer and it's redefined here to
            # use `deep_keys_camelize`
            renderer_methods = %i(_render_option_json _render_with_renderer_json)
            renderer_methods.each do |renderer_method|
              define_method(renderer_method) do |resource, options|
                # `get_serializer` is a method from ActiveModel::Serializer and
                # it's defined in `lib/action_controller/serialization.rb`
                serializer = get_serializer(resource, options)

                if serializer
                  resource = serializer
                  options.delete(:serializer)
                  options.delete(:each_serializer)
                end

                resource = resource.as_json
                resource = resource.deep_keys_camelize if camel_case?

                super(resource, options)
              end
            end

            private

            def camel_case?
              request.headers["HTTP_X_KEY_FORMAT"] == "camelCase"
            end
          end
        end
      end
    end
  end
end
