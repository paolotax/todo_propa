module ScuoleHelper
  
  def scuola_for_mustache(scuola)
    {
      url: scuola_url(scuola),
      nome: scuola.nome,
      citta: scuola.citta,
      provincia: scuola.provincia
    }
  end
  
end
