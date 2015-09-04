require_relative '../src/probando_cosas'

class Aspect

  def self.on (*parametros, &bloque)
    # debo encontrar todas las clases y modulos dentro de programa
    # que matcheen con las expRegulares que pasan como parametros

    # Hay que hacerle include a los origenes
  #  parametros.each do
  #    |ob|
  #    if !ob.class.is_a? Class
  #      ob.singleton_class.include(A)
  #    else
  #      ob.include(A)
  #    end

  # end

    # forma mas piola de hacer eso de sacar todas las clases y modulos que hay
    select_origins(*parametros, &bloque)

    # forma deprecated. Lo dejo para ver nomas
    #parametros.each {|unParametro|
    # origenes.push (ObjectSpace.each_object(Module).to_a.select {|unObjeto| regular_exp_de(unParametro).match(unObjeto.to_s)})
    #}

 #   origenes.each {|unOrigen| unOrigen.definir_aspecto(bloque)}

    # no pude hacer la validacion de que no encuentra origen dada expReg erronea

    # no se porque, pero para usar este metodo me lo pide de clase
    # se que ponerla aca es totalmente un error. Es solo para probar

    #no esta probado y dudo seriamente que esto ande. Ademas se puede hacer de otras formas...
    #def self.regular_exp_de (un_elemento)
    #  unless (un_elemento.instance_of? (Regexp))
    #    Regexp.new(un_elemento.to_s)
    #  end
    #end

  end

  def self.select_origins(*parametros,&bloque)
    totales = (Object.constants.map(&Object.method(:const_get)).grep(Class) + Object.constants.map(&Object.method(:const_get)).grep(Module)).uniq

    # para validar que tire error al no recibir parametros
    if parametros.empty?
      raise ArgumentError.new 'wrong number of arguments (0 for +1)'
    end

    origenes = Array.new

    parametros.each do
    |unParametro|
      if unParametro.instance_of? (Regexp)
        origenes.concat(totales.select { |unObjeto| unObjeto.name=~unParametro }.uniq)
      else
        origenes << unParametro
      end
    end
=begin
    clases = origenes.select { |o| o.instance_of? Class }
    clases.each { |c| c.include(A) }

    instancias = origenes - clases
    instancias.each { |i| i.extend(A) }

    clases.each { |c| c.send(:define_method, :nuevo_metodo, bloque) }
    instancias.each { |i| i.singleton_class.send(:define_method, :nuevo_metodo, bloque) }
=end
    return origenes
  end


end