require 'zlib'
require 'smarter_csv'
require 'activerecord-import'

namespace :data do
  desc 'Import csv data'
  task :import => :environment do
    filename = 'tmp/engineering_project_businesses.csv'
    Zlib::GzipReader.open('data/engineering_project_businesses.csv.gz') do |input|
      File.open(filename, "w") do |output|
        IO.copy_stream(input, output)
      end
    end

    options = {chunk_size: 5000}
    SmarterCSV.process(filename, options) do |chunk|
      businesses = chunk.map {|b| Business.new(b)}
      Business.import(businesses, validate: false)
      print '.'
    end

    File.delete(filename)
  end
end