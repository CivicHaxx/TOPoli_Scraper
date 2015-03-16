# TOPoli Scraper

This scraper is a work in progress that scrapes the City of Toronto Council data. When it is complete, it will scrape Agendas, Minutes, Decision Documents, and the Vote Record and save it all to a Database. The scraper will integrate with an API so that you can get all of this info as JSON.

Here's what we're working on:

## Scraper Class
- methods: 
  + `save` saves file to hard drive
  + `post` sends a post request to remote server
    * params: url, form
      - url is a URI 
      - form is a hash
  + `deep_clean`
    * requires more research on Nokogiri and Loofah
    * could extend `String`
    * or be a method on the parent class
    * converts strings (files before they've been saved) to UTF-8
    * looks for unknown chars and replaces them with the correct char
    * right now, the deep_clean method replaced a bunch of chars with diacritics

## Meeting Scraper Class
- child of Scraper
- has children "Agenda", "Minutes", and "DecisionDocs"
  + each of these scrape their respective docs

### Basic tasks of a _DocName_Scraper
- gets raw HTML and saves it to the HD 
  + depending on the reliability of our scrubber, it could scrub before it saves. This would be much faster.
- Creates _DocName_ in the DB (i.e., Agenda, Minutes, or DecisionDocs)
- Parses the document into it's items, motions, and decisions
- saves items motions and decisions to the db

### Agenda Scraper
- relies on meeting ids to get the ids of all meetings from one year
- relies on raw_agenda to get the agenda and save it to the HD
- relies on parsed_item to break item into sections and return a hash of the items sections

### Note on Agendas Minutes and Decision Docs Scrapers
- We need to look more closely at this. There might be some overlap between the three.
  + For example, I think the Decision Docs contain the final item as well as all the motions that modified the original item.

## Vote Record Scraper
- Child of Scraper
- Gets CSVs, 
  + scrubs them
  + saves them
  + creates them in the RawVoteRecord table
- Uses the RawVoteRecord to create new votes and their associations in the app
