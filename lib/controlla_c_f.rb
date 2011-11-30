# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Author::    Giulio Turetta  (mailto:giulio@sviluppoweb.eu)
# Copyright:: Copyright (c) 2009 Giulio Turetta
# License::   GNU General Public License

# Questa classe implementa un metodo valid? per controllare la validità
# formale di un Codice Fiscale.
# Il metodo valid? ritorna true nel caso in cui il test ha esito positivo
# (cod. fiscale valido) e false nel caso contrario (cod. fiscale non valido).
# Se esistono dei problemi formali come lunghezza errata o stringa vuota 
# vengono sollevate apposite eccezioni: ControllaCF::InvalidLength nel 
# primo caso, ControllaCF::EmptyString nel secondo.
# Il metodo accetta sia lettere minuscole che lettere maiuscole.
# Se si desidera operare distinzione tra maiuscole e minuscole passare true
# come secondo argomento, in caso di minuscole sarà sollevata 
# l'apposita eccezione ControllaCF::CaseError

class ControllaCF
  LT = [[1,'0'],[0,'1'],[5,'2'],[7,'3'],[9,'4'],[13,'5'],[15,'6'],[17,'7'],[19,'8'],[21,'9'],[1,'A'],[0,'B'],[5,'C'],[7,'D'],[9,'E'],[13,'F'],[15,'G'],[17,'H'],[19,'I'],[21,'J'],[2,'K'],[4,'L'],[18,'M'],[20,'N'],[11,'O'],[3,'P'],[6,'Q'],[8,'R'],[12,'S'],[14,'T'],[16,'U'],[10,'V'],[22,'W'],[25,'X'],[24,'Y'],[23,'Z']]
  Z9 = ('0'..'9').to_a
  AZ = ('A'..'Z').to_a
  class EmptyString < Exception; end
  class InvalidLength < Exception; end
  class CaseError < Exception; end
  def self.valid?(cf, strict = false)
    cf = cf.to_s
    raise EmptyString.new("codice fiscale non puo' essere lasciato in bianco") if cf.empty?
    raise InvalidLength.new("codice fiscale dev'essere composto da 16 caratteri alfanumerici") if cf.size != 16
    if strict==true && cf != cf.upcase; raise CaseError.new("i caratteri del codice fiscale devono essere maiuscoli"); else cf.upcase! end;
    s = (0..14).collect {|i| (i&1)!=0 ? ([Z9.include?(cf[i,1]) ? cf[i,1].to_i : AZ.index(cf[i,1]),cf[i,1]]) : LT.rassoc(cf[i,1])}
    s.include?(nil) ? false : AZ.at((s.transpose[0].inject(0){|t,n| t+n})%26) == cf[-1,1]
  end
end