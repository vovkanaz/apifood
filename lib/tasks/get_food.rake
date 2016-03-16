desc 'Get food'
task get_food: :environment do
  Manager.handle_order
end