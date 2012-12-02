# require 'csv'    


namespace :tax do
  desc "Carica i comuni da listacomuni.txt"
  task :carica_comuni => :environment do
    # csv_text = File.read('../../tmp/lista_comuni.txt')
    # csv = CSV.parse(csv_text, :headers => true)
    # csv.each do |row|
    #   row = row.to_hash.with_indifferent_access
    #   Comune.create!(row.to_hash.symbolize_keys)
    # end
  end

  task :carica_meteo => :environment do

	  Cliente.all.each do |video|
	    json_stream = open("http://api.embed.ly/1/oembed?key=08b652e6b3ea11e0ae3f4040d3dc5c07&url=#{video.video_url}&maxwidth=525")
	    ruby_hash = JSON.parse(json_stream.read)
	    thumbnail_url = ruby_hash['thumbnail_url']
	    embed_code = ruby_hash['html']
	    video.update_attributes(:thumbnail_url => thumbnail_url, :embed_code => embed_code)
  	end
  end	  
end

end

