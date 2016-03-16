desc 'Get food'
task get_food: :environment do
  FinalOrder.handle_order
end