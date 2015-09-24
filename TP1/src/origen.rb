require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :fuente, :metodo, :instancias, :hashes, :origen_padre, :metodos, :ejecutadores, :receptor, :logica, :continuacion

  def initialize
    self.instancias = {}
    self.metodos = {}
    self.ejecutadores = {}
  end

  def where(*condiciones)
    self.all_methods.select do
      |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end

  def transform(*metodos_filtrados, &transformaciones)
    metodos_filtrados.flatten.each do
      |metodo|

      self.metodo = self.target.instance_method(metodo)

      #Diccionario cuyas claves son metodos, y sus valores los parametros de cada metodo
      self.metodos[metodo] = self.metodo
      self.definir(metodo)

      self.instance_eval &transformaciones
    end
  end

  def definir(metodo)

    bloque_origen = proc do
    |una_instancia, *args|
        self.instancias[__method__].send(__method__, una_instancia, *args)
    end

    self.singleton_class.send(:define_method, metodo, &bloque_origen)

    bloque_fuente = proc do
    |*args|
      self.origen.send(__method__, self, *args)
    end

    self.target.send(:define_method, metodo, &bloque_fuente)

    end

  def self.redireccionar(instancia_fuente, metodo, *args)

    claves = self.origenes_por_fuente.keys
    valores = self.origenes_por_fuente.values

    if claves.include? instancia_fuente.class
      valores[claves.index instancia_fuente.class].send(metodo, *args)
    else
      valores[claves.index instancia_fuente.singleton_class].send(metodo, *args)
    end

  end

  def agregar_origen_para(metodo, obj)
    if self.instancias[metodo] == nil
      self.instancias[metodo] = obj
    else
      self.instancias[metodo].agregar_origen(obj)
    end
  end

  def agregar_origen(obj)
    if self.fuente.is_a? Origen
      self.fuente.agregar_origen(obj)
    else
      self.fuente = obj
    end
  end

  def ultimo_de_la_cadena
    if self.fuente.is_a? Origen
      self.fuente.ultimo_de_la_cadena
    else
      self.fuente
    end
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end

  def target
    (self.fuente.instance_of? Class or self.fuente.instance_of? Module) ? self.fuente : self.fuente.singleton_class
  end

  def instancia_de_fuente

    if self.fuente.instance_of? Module
      instancia = God.include(Module).new
    else if self.fuente.instance_of? Class
           instancia = fuente.new
         else
           instancia = fuente.clone
         end
    end
    instancia
  end
end



