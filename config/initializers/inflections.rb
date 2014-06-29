# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):

ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
  inflect.irregular 'cliente', 'clienti'
  inflect.irregular 'scuola', 'scuole'
  inflect.irregular 'appunto', 'appunti'
  inflect.irregular 'persona', 'persone'
  inflect.irregular 'visita', 'visite'   
  inflect.irregular 'indirizzo', 'indirizzi'
  inflect.irregular 'telefono', 'telefoni'
  inflect.irregular 'libro', 'libri'
  inflect.irregular 'librino', 'librini'
  inflect.irregular 'riga', 'righe'
  inflect.irregular 'fattura', 'fatture'
  inflect.irregular 'insegnante', 'insegnanti'
  inflect.irregular 'classe', 'classi'
  inflect.irregular 'adozione', 'adozioni'
  inflect.irregular 'materia', 'materie'
  inflect.irregular 'tappa', 'tappe'
  inflect.irregular 'sezione', 'sezioni'
  inflect.irregular 'giro', 'giri'
  inflect.irregular 'copia', 'copie'
  inflect.irregular 'comune', 'comuni'
  inflect.irregular 'magazzino', 'magazzini'
  inflect.irregular 'buono di consegna', 'buoni di consegna'
  inflect.irregular 'nota di accredito', 'note di accredito'
  inflect.irregular 'ordine', 'ordini'
  inflect.irregular 'documento', 'documenti'
  inflect.irregular 'editore', 'editori'
  
  # inflect.plural /^([\w]*)a/i, '\1e'
  # inflect.singular /^([\w]*)e/i, '\1a'
  # inflect.plural /^([\w]*)o/i, '\1i'
  # inflect.singular /^([\w]*)i/i, '\1o'
  
  # inflect.uncountable %w( fish sheep )
end
