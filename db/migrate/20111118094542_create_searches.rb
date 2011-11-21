class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :title
      t.string :model
      t.string :keywords
      t.string :destinatario
      t.string :note
      t.string :stato
      t.string :scuola
      t.string :citta
      t.string :provincia
      t.string :zona
      t.string :tag_list 
      t.timestamps
    end
  end
end
