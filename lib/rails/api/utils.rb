require "active_model_serializers"

module Rails
  module API
    module Utils
      module Controllers
        autoload :RenderConcern, "rails/api/utils/controllers/concerns/render_concern"
      end
    end
  end
end
