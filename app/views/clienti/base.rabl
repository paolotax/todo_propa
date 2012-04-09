attributes :id, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email
           
code do |u|
  { 
    nel_baule:    u.nel_baule
  }
end
