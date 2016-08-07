require 'csv'

namespace :data do
  desc 'Import csv data'
  task :import => :environment do
    `gzip -kd data/engineering_project_businesses.csv.gz`
    filename = 'data/engineering_project_businesses.csv'
    CSV.foreach(filename, :headers => true) do |row|
      Business.create!(row.to_hash)
    end
    `rm data/engineering_project_businesses.csv`
  end
end