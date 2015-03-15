require_relative 'raw_agenda'
require_relative 'parsed_item'
require_relative 'meeting_ids'
require_relative 'scraper'

class AgendaScraper < Scraper

  def initialize(year, dirty = false)
    @year        = 2014
    @dirty       = dirty
    @agenda_dir  = agenda_dir
    @meeting_ids = meeting_ids
  end

  # DIRTY      = args.clean == "-d" ? true : false
  # DIRTY by default so that we're working with the original docs.
  # Remove this when we have a better cleaner working.
	
  def agenda_dir
    @dirty == true ? "lib/dirty_agendas" : "lib/agendas"
  end
  
  def meeting_ids
   MeetingIDs.new(12, @year).ids
	end

  # TO DO run through parsed aganda items and save each as Item in db.
  def run
    save_agendas
    #parsed_agena_items
    puts "★ ★ ★  DONE ★ ★ ★"
  end

  def parsed_agenda_items # returns an array of agenda item hashes
    @meeting_ids.map do |id|
      start = Time.now.to_f
      print "Parsing #{id} "
      
      content  = open("#{@agenda_dir}/#{id}.html").read
      sections = content.split("<br clear=\"all\">")
      items    = sections.map { |item| Nokogiri::HTML(item) }
      
      items.map do |item|
        item_number = item.xpath("//table[@class='border']/tr/td/font[@size='5']").text

        unless item_number.empty?
          ParsedItem.new(item_number, item).to_h
        end
      end
      puts "⚡" * ((Time.now.to_f - start)*50)
    end
  end

  def save_agendas
    @meeting_ids.map do |id|
      unless File.exist? "#{@agenda_dir}/#{id}.html"
        print "Saving #{id}"
        RawAgenda.new(id).save
        puts " ✔ "
      end
    end
  end
end
