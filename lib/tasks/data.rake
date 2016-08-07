require 'smarter_csv'
require 'activerecord-import'

namespace :data do
  desc 'Import csv data'
  task :import => :environment do
    `gzip -kd data/engineering_project_businesses.csv.gz`

    filename = 'data/engineering_project_businesses.csv'
    options = {chunk_size: 5000}
    SmarterCSV.process(filename, options) do |chunk|
      businesses = chunk.map {|b| Business.new(b)}
      Business.import(businesses)
      print '.'
    end

    `rm data/engineering_project_businesses.csv`
  end
end