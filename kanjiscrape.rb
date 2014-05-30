#encoding: utf-8
#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

require 'nokogiri'
require 'open-uri'
#html = open("http://jisho.org/words?jap=#{URI::encode('氷河')}&eng=&dict=edict")
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
#p address
#BASE_URL = "http://jisho.org/words?jap="
#list = ['予', '期', '感化']
#list2 = list.map { |trans| URI::encode(trans) }
#list2.each do |word|
  
#  html = open("#{BASE_URL}#{word}&eng=&dict=edict")
#  page = Nokogiri::HTML(html.read)
#  page.delete('.lower')
#  puts page.css('#result_content #word_result tr').text #if page.css('#word_result tr').text.match(/#{word}/)
#  sleep(1.0 + rand)
#end
#TO DO remove .lower nodes and transform garbage into kanji... how?
#page = Nokogiri::HTML(open("http://jisho.org/words?jap=感&eng=&dict=edict"))
#puts URI::encode('感')
#page = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_Nobel_laureates"))
#puts page
#puts page.css('title')
#puts page.css('li')
#puts page.css('li')[0].text
#puts page.css('li')[0].css('a')[0]['href']
#puts page.css("li a[data-category='news']")
#puts page.css("li").text
#puts page.css('div#funstuff')
#page.css('div#references a').each do |link|
#  puts link['href']
#end 
#links = []
#page.css("table span.fn a").each do |link|
#  links << link['href'] if link['href'].match(/wiki/)
#end
#puts links.length
#links.uniq
#puts links.length

#puts links


