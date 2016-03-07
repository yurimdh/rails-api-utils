module Rails
  module API
    module Utils
      module Controllers
        module IncludeConcern
          extend ActiveSupport::Concern

          included do
            attr_reader :includes

            def include!(*permitted)
              param! :include, String, require: true, default: ""
              permitted.map!(&:to_s)

              @includes = []

              params[:include].split(",").each do |included|
                if permitted.include?(included)
                  @includes << included.to_sym
                else
                  exception = RailsParam::Param::InvalidParameterError.new(
                    "'includes' must be within #{permitted.join(', ')}"
                  )
                  exception.param = :includes

                  raise exception
                end
              end
            end
          end
        end
      end
    end
  end
end
