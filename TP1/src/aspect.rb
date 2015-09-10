require_relative '../src/probando_cosas'

class Aspect
  attr_accessor :origenes

  def self.on (*parametros, &bloque)

    fuentes = select_origins(*parametros)
    fuentes.each do
      |fuente|
      origen = Origen.new(fuente)
      @origenes.add(origen)
      origen.instance_eval &bloque
    end

  end



  def self.select_origins(*parametros)

    if parametros.empty?
      raise ArgumentError.new 'wrong number of arguments (0 for +1)'
    end

    totales = (Object.constants.map(&Object.method(:const_get)).grep(Class) + Object.constants.map(&Object.method(:const_get)).grep(Module)).uniq

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
end