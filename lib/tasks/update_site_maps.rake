desc 'Update site maps'
task update_site_maps: :environment do
  CalendarController.update_site_maps
end