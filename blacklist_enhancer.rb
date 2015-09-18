#!/usr/bin/env ruby

require_relative 'blacklist_words_censor'

require 'nokogiri'
require 'open-uri'

# JurisPrivacy
module JurisPrivacy
  # BlacklistEnhancer
  class BlacklistEnhancer
    BLACKLIST_DATA_PATH = 'blacklist_words_it.data'

    def initialize(blacklist = Blacklist.new(BLACKLIST_DATA_PATH))
      @blacklist = blacklist
      @blacklist_words_censor = BlacklistWordsCensor.new @blacklist
    end

    def go
      puts 'Dangerous words:'
      loop do
        doc = Nokogiri::HTML(open('https://it.wikipedia.org/wiki/Special:Random'))
        wiki_text = doc.at('body').text
        censored_words = @blacklist_words_censor.inspect(wiki_text).values
        dangerous_words = censored_words.delete_if { |word| word =~ /^[A-Z]/ }
        dangerous_words.uniq!
        print dangerous_words.join(',') unless dangerous_words.empty?
      end
    end
  end

  BlacklistEnhancer.new.go
end
