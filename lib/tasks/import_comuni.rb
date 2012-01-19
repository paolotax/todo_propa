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

end

