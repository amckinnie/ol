require 'zlib'
require 'smarter_csv'
require 'activerecord-import'

namespace :data do
  desc 'Import csv data'
  task :import => :environment do
    # Unzip the csv into a temp file
    filename = 'tmp/engineering_project_businesses.csv'
    Zlib::GzipReader.open('data/engineering_project_businesses.csv.gz') do |input|
      File.open(filename, "w") do |output|
        IO.copy_stream(input, output)
      end
    end

    # import data 5000 lines at a time
    options = {chunk_size: 5000}
    SmarterCSV.process(filename, options) do |chunk|
      businesses = chunk.map {|b| Business.new(b)}
      # import is used instead of a direct insert query in case validations
      # are needed in future versions
      Business.import(businesses, validate: false)
      print '.'
    end

    # remove temp file
    File.delete(filename)
  end
end