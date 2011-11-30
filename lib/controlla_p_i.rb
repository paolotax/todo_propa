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
# formale di una Partita IVA.
# Il metodo valid? ritorna true nel caso in cui il test ha esito positivo
# (p.iva valida) e false nel caso contrario (p.iva non valida).
# Se esistono dei problemi formali come lunghezza errata o stringa vuota 
# vengono sollevate apposite eccezioni: ControllaPI::InvalidLength nel 
# primo caso, ControllaPI::EmptyString nel secondo.

class ControllaPI
  NU = ('0'..'9').to_a
  class EmptyString < Exception; end
  class InvalidLength < Exception; end
  def self.valid?(pi)
    pi = pi.to_s
    raise EmptyString.new("partita iva non può essere lasciata in bianco") if pi.empty?
    raise InvalidLength.new("partita iva dev'essere composta da 11 cifre") if pi.size != 11
    s = (0..9).collect {|i| NU.include?(pi[i,1]) ? ((i&1)!=0 ? (pi[i,1].to_i > 4 ? ((pi[i,1].to_i*2) - 9) : pi[i,1].to_i * 2) : pi[i,1].to_i) : nil}
    r = s.include?(nil) ? false : ((s.inject(0){|t,n| t+n}) % 10)
    r != false && (r==0 ? r: 10-r) == pi[-1,1].to_i
  end
end