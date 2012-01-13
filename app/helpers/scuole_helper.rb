module ScuoleHelper
  
  def scuola_for_mustache(scuola)
    {
      url: scuola_url(scuola.id),
      nome: scuola.nome,
      citta: scuola.citta,
      provincia: scuola.provincia
    }
  end
  
end
