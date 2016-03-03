desc 'Update site map'
task update_site_map: :environment do
  CalendarController.update_site_map
end