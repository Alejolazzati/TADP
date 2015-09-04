require_relative '../src/probando_cosas'

class Aspect

  def self.on (*parametros, &bloque)

    origenes = select_origins(*parametros)

    clases_y_modulos = clases_de(*origenes).concat modulos_de(*origenes)

    clases_y_modulos.each do
     |unaClase|
      unaClase.include(A)
      unaClase.send(:define_method, :nuevo_metodo, bloque)
    end

    (origenes - clases_y_modulos).each do
      |unaInstancia|
      unaInstancia.extend(A)
      unaInstancia.singleton_class.send(:define_method, :nuevo_metodo, bloque)
    end

  end

  def self.select_origins(*parametros)
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

    return origenes
  end

  def self.clases_de(*origenes)
    origenes.select { |o| o.instance_of? Class }
  end

  def self.modulos_de(*origenes)
    origenes.select { |o| o.instance_of? Module }
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
