
# se que esto que hago aca ahora se puede diseñar mucho mejor.
# es solo para ver como hacerlo andar e ir probando cosas

module A
  def where
    'FUNQUE AMEEEOO!! EAEAEAEA AGUANTE LAS PUTAS EAEA'
  end
end

class Aspects
  def self.on (*parametros, &bloque)
    # debo encontrar todas las clases y modulos dentro de programa
    # que matcheen con las expRegulares que pasan como parametros

    # Hay que hacerle include a los origenes
    parametros.each do
      |ob|
      ob.singleton_class.include(A)

    end

    # forma mas piola de hacer eso de sacar todas las clases y modulos que hay
     totales = (Object.constants.map(&Object.method(:const_get)).grep(Class) + Object.constants.map(&Object.method(:const_get)).grep(Module)).uniq

    # para validar que tire error al no recibir parametros
    if parametros.empty?
      raise ArgumentError.new 'wrong number of arguments (0 for +1)'
    end

    origenes = Array.new

    parametros.each do
      |unParametro|
      if !unParametro.instance_of? (Regexp)
        origenes << unParametro
      else
        origenes.concat(totales.select{|unObjeto| unObjeto.name=~unParametro}.uniq)
      end

    end

    # forma deprecated. Lo dejo para ver nomas
    #parametros.each {|unParametro|
     # origenes.push (ObjectSpace.each_object(Module).to_a.select {|unObjeto| regular_exp_de(unParametro).match(unObjeto.to_s)})
    #}


   # origenes.flatten.each {|unOrigen| unOrigen.definir_aspecto(bloque)}
     origenes.each {|unOrigen| unOrigen.definir_aspecto(bloque)}

    # no pude hacer la validacion de que no encuentra origen dada expReg erronea

  end

  # no se porque, pero para usar este metodo me lo pide de clase
  # se que ponerla aca es totalmente un error. Es solo para probar

  #no esta probado y dudo seriamente que esto ande. Ademas se puede hacer de otras formas...
  #def self.regular_exp_de (un_elemento)
  #  unless (un_elemento.instance_of? (Regexp))
  #    Regexp.new(un_elemento.to_s)
  #  end
  #end
end

# Al definir el metodo en Module, por herencia lo tiene Class
# => no es necesario porner el metodo definir_aspecto en Class, ya lo va a tener
# en Object si (hace otra cosa), Module hereda de este y el mismo redefine el metodo en cuestion.
# igualmente esto es solo para probar que ande. No es necesario este metodo en particular
class Module
  def definir_aspecto(bloque)
    self.send(:define_method, :nuevo_metodo, bloque)
  end
end

class Objectc
  def definir_aspecto (bloque)
    self.singleton_class.send(:define_method, :nuevo_metodo, bloque)
  end
end