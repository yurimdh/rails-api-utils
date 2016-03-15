module Rails
  module API
    module Utils
      class Railtie < Rails::Railtie
        initializer "deep_keys_camelize" do
          class ::Object
            def deep_keys_camelize
              case self
              when Array
                map(&:deep_keys_camelize)
              when Hash
                Hash[map do |k, v|
                  [k.to_s.camelize(:lower), v.deep_keys_camelize]
                end]
              else
                self
              end
            end
          end
        end
      end
    end
  end
end
