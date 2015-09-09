require_relative '../src/origen'

class Aspect

  def self.on (*parametros, &bloque)

    origenes = select_origins(*parametros)

    origenes each do
    |unOrigen|
      unOrigen.singleton_class.include(Origen)
      unOrigen.instance_eval &bloque
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

    if origenes.empty?
      raise ArgumentError.new 'Origen vacio'
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
