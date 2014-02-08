class Numeric

  def to_italian
    # Decimali
    finale = self.class == Float ? "/" + ((self % 1 + 0.001) * 100).to_i.to_s : "/00"
    working = self.to_i

    result = ""
    # Cicliamo tra gruppi di migliaia per convertire i numeri
    9.step(3, -3) do |n|
      # Eseguiamo solo se il numero è effettivamente nell'ordine di grandezza di 10^n
      result += (working / 10 ** n).descrivi + SUFFIXES[n] if
      Math.log10(working).to_i >=n
      # Prendiamo il resto della divisione e proseguiamo
      working %= 10 ** n
    end
    
    result += working.descrivi + finale
    # Trasformiamo la stringa in una stringa pulita senza imperfezioni ortografiche
    EXCEPTIONS.each_pair {|k,v| result.gsub!(k,v)}

    result
  end
  

  protected
    
    # Insieme delle eccezioni che vanno applicate al risultato finale
    EXCEPTIONS = {
      "unocento"  => "cento",
      "unomila"   => "mille",
      "unom"      => "unm",
      /t\wmille/  => "tunomila",
      "antaotto"  => "antotto",
      "antauno"   => "antuno"
    }

    # Unità e decine fino a novanta
    NUMERI = {
      :unita  => ["", "uno", "due", "tre", "quattro", "cinque", "sei", "sette", "otto", "nove"],
      :teen   => ["dieci", "undici", "dodici", "tredici", "quattordici", "quindici", "sedici", "diciassette", "diciotto", "diciannove"],
      :decine => ["", "dieci", "venti", "trenta", "quaranta", "cinquanta", "sessanta", "settanta", "ottanta", "novanta"]
    }

    # I suffissi per migliaia milioni e miliardi
    SUFFIXES = {3 => "mila", 6 => "milioni", 9 => "miliardi"}


    def descrivi
      working = self
      risultato = ""
      risultato += NUMERI[:unita][working / 100] + "cento" if working >= 100
      if (working %= 100) >= 20
       risultato += NUMERI[:decine][working / 10]
      elsif working >= 10 && working < 20
       risultato += NUMERI[:teen][working % 10]
       working = 0
      end
      risultato + NUMERI[:unita][working % 10]
    end




end
