module ClientiHelper
  
  def cliente_for_mustache(cliente)
    {
      url: cliente_url(cliente.id),
      nome: cliente.nome,
      citta: cliente.citta,
      provincia: cliente.provincia
    }
  end
  
end
