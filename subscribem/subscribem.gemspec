$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "subscribem/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "subscribem"
  s.version     = Subscribem::VERSION
  s.authors     = ["Ryan Bigg"]
  s.email       = ["me@ryanbigg.com"]
  s.homepage    = "https://github.com/radar/saas_book_examples"
  s.summary     = "Subscribem gem from Mulitenancy with Rails"
  s.description = "Subscribem gem from Mulitenancy with Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.2"
  s.add_dependency "bcrypt", "3.1.7"
  s.add_dependency "warden", "1.2.3"
  s.add_dependency "dynamic_form", "1.1.4"
  s.add_dependency "pg"
  s.add_dependency "houser", "1.0.2"
  s.add_dependency "braintree", "~> 2.40"

  s.add_development_dependency "rspec-rails", "3.0.1"
  s.add_development_dependency "capybara", "2.3.0"
  s.add_development_dependency "factory_girl", "4.4.0"
  s.add_development_dependency "database_cleaner", "1.3.0"
end
