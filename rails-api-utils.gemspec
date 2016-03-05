$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails/api/utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-api-utils"
  s.version     = Rails::API::Utils::VERSION
  s.authors     = ["Willian Fernandes"]
  s.email       = ["willian@willianfernandes.com.br"]
  s.homepage    = "http://github.com/willian/rails-api-utils"
  s.summary     = "TODO: Summary of Rails::API::Utils."
  s.description = "Adds some utilites when using Rails for APIs with ActiveModel::Serializer"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0.beta2", "< 5.1"
  s.add_dependency "active_model_serializers", "0.10.0.rc4", "< 0.11"
  s.add_dependency "rails_param", "0.9.0", "< 1.0"
  s.add_development_dependency "byebug"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "simplecov"
end
