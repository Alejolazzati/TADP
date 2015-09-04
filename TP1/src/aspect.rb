require_relative '../src/probando_cosas'

class Aspect

  def self.on (*parametros, &bloque)

    select_origins(*parametros)

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