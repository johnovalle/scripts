#encoding: utf-8
#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

require 'nokogiri'
require 'open-uri'
kanjis = [] #file.open kanji file
duplicates = []
File.open('kanji.txt', 'r').each { |line| kanjis << line.chomp }
address = Hash[kanjis.map { |trans| [trans, URI::encode(trans)] }]
entries = []
address.each do |kanji, addy|
  html = open("http://jisho.org/words?jap=#{addy}&eng=&dict=edict")
  page = Nokogiri::HTML(html.read)
  page.css('tr').each do |match|
    catcher = []
    if match.css('.kanji').text.match(/^#{kanji}\s/)
      catcher << match.css('.kanji').text.strip
      catcher << match.css('.kana_column').text.strip
      catcher << match.css('.meanings_column').text.strip#.gsub!(/^\s+/, '')#.gsub!(/\s+$/, '')
      entries.each { |entry| duplicates << catcher[0] if entry.include?(catcher[0]) }
      entries << catcher
    end 
  end
  sleep(1.0 + rand)
end

### write to file
write_file = File.open('kanjiout.txt', 'w')

entries.each do |entry|
  write_file.puts entry[0] + "\t" + entry[1] + "\t" + entry[2]
end
write_file.close
duplicates.uniq!
puts duplicates.length
puts duplicates

