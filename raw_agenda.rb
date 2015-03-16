require_relative 'scraper'

class RawAgenda < Scraper
	attr_reader :id
	
	def initialize(id)
		@id = id
	end

	def name
		"#{@id}.html"
	end

	def filename
		"#{AGENDA_DIR}/#{name}"
	end

	def url
		URI "#{BASE_URI}viewPublishedReport.do?"
	end

	def agenda_params(meeting_id)
	  {
	    function:  "getCouncilAgendaReport",
	    meetingId: meeting_id
	  }
	end

	# TO DO: hook up the html stripper and start using clean data! 
	def content
		content = post(agenda_params(id))
		content = content.to_s
					 					 .scrub
					 					 .encode(
					 						 'UTF-8', 
					 						 { :invalid => :replace, 
					 							 :undef   => :replace, 
					 							 :replace => '�'
					 						 })
		if DIRTY
			content
		else
			parser  = HTMLCleaner.new
			content = parser.parse_html!(content).to_s
			content
		end
	end
end