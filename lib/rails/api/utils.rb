require "active_model_serializers"
require "rails/api/utils/railtie"

module Rails
  module API
    module Utils
      module Controllers
        autoload :IncludeConcern, "rails/api/utils/controllers/concerns/include_concern"
        autoload :RenderConcern, "rails/api/utils/controllers/concerns/render_concern"
      end
    end
  end
end
