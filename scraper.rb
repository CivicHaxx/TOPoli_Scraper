puts Dir.pwd
require 'active_record'
require 'active_support/all'
require 'action_view/helpers'
require 'awesome_print'
require 'colored'
require 'csv'
require 'http'
require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

	BASE_URI   = "http://app.toronto.ca/tmmis/"

	def post(params)
    HTTP.with_headers("User-Agent" => "INTERNET EXPLORER").post(url, form: params).body.to_s
  end

	def deep_clean(string)
    string.scrub.encode('UTF-8', { invalid: :replace, undef: :replace, replace: '�'})
  end

  def save(name, content)
    File.open(filename(name), 'w') { |f| f.write (content) }
  end

end


binding.pry

puts ""