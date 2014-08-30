require "subscribem/braintree_plan_fetcher"
namespace :subscribem do
  desc "Import plans from Braintree"
  task :import_plans => :environment do
    Subscribem::BraintreePlanFetcher.store_locally
  end
end