class AddFieldsToClienti < ActiveRecord::Migration
  

  
  def change
    add_column :clienti, :cliente_tipo, :string
    add_column :clienti, :codice_fiscale, :string
    add_column :clienti, :partita_iva, :string
  

    say "Reset cliente_tipo"
    Cliente.reset_column_information

    Cliente.all.each do |s|
      if s.nome =~ /E (.*)/
        s.cliente_tipo = "Scuola Primaria"
      elsif s.nome =~ /C (.*)/
        s.cliente_tipo = "Cartoleria"
      elsif s.nome =~ /IC (.*)/
        s.cliente_tipo = "Direzione"
      elsif s.nome =~ /D (.*)/
        s.cliente_tipo = "Direzione"
      else
        s.cliente_tipo = "Privato"
      end
      
      s.save
    end
  end

end
