desc 'Update site map'
task update_site_map: :environment do
  FinalOrder.update_site_map
end