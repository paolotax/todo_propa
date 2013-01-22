class LibroSerializer < ActiveModel::Serializer

	attributes :id, :autore, :titolo, :sigla, :prezzo_copertina, :prezzo_consigliato, 
						 :coefficente, :cm, :ean, :settore, :materia_id, :image

end