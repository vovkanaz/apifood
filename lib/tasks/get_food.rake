desc 'Get food'
task get_food: :environment do
  DeferredJob.perform_later
end