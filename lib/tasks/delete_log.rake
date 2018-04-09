namespace :delete do
  task :log_activity => :environment do
    n_removed = 0
    versions = PaperTrail::Version.all

    versions.each do |version|
      if Time.zone.today - version.created_at.to_date > 90
        n_removed += 1
        version.destroy
      end
    end

    puts "Removed #{n_removed} records. [#{DateTime.now}]" unless Rails.env.test?
  end
end
