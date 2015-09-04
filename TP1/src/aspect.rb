require_relative '../src/probando_cosas'

class Aspect

  def self.on (*parametros, &bloque)

    origenes = select_origins(*parametros)
    agregar_mixin(origenes, A)

#    agregar_metodo(origenes, &bloque)

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

  def self.agregar_mixin(*origenes, unMixin)

    clases = self.clases_de(*origenes)
    modulos = self.modulos_de(*origenes)
    instancias = self.instancias_de(*origenes)

    incluir_mixin(clases, unMixin, :itself)
    incluir_mixin(modulos, unMixin, :itself)
    incluir_mixin(instancias, unMixin, :singleton_class)

  end

  def self.incluir_mixin(*objetos, unMixin, mensaje_identidad_objetos)
    objetos.each do
      |unObjeto|
      receptor = unObjeto.send(mensaje_identidad_objetos)
      receptor.include(unMixin)

    end
  end

  def self.agregar_metodo(*origenes, &bloque)

    clases = self.clases_de(*origenes)
    modulos = self.modulos_de(*origenes)
    instancias = self.instancias_de(*origenes)

    definir_nuevo_metodo(clases, :itself, &bloque)
    definir_nuevo_metodo(modulos, :itself, &bloque)
    definir_nuevo_metodo(instancias, :singleton_class, &bloque)

  end

  def self.definir_nuevo_metodo(*objetos, mensaje_identidad_objetos, &bloque)
    objetos.each do
      |unObjeto|
      unObjeto = unObjeto.send(mensaje_identidad_objetos)
      unObjeto.send(:define_method, :nuevo_metodo, bloque)
    end

  end

  def self.clases_de(*origenes)
    origenes.select { |o| o.instance_of? Class }
  end

  def self.modulos_de(*origenes)
    origenes.select { |o| o.instance_of? Module }
  end

  def self.instancias_de(*origenes)
    origenes - self.clases_de(*origenes) - self.modulos_de(*origenes)
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
