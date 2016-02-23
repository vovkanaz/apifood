desc 'Get food'
task get_food: :environment do
 CalendarController.handle_order
end