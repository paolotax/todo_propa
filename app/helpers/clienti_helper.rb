module ClientiHelper
  
  def cliente_for_mustache(cliente)
    {
      id: cliente.id,
      nome: cliente.nome,
      citta: cliente.citta,
      provincia: cliente.provincia
    }
  end
  
end
