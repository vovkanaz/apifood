desc 'Update site map'
task update_site_map: :environment do
  Manager.update_site_map
end