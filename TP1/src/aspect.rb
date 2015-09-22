class Aspect

  def self.on (*parametros, &bloque)
    fuentes = select_origins(*parametros)
    fuentes.each do
      |fuente|

      origen = Origen.new()
      origen.fuente = fuente

=begin
      if fuente.instance_of? Module
        instancia = God.include(Module).new
      else if fuente.instance_of? Class
             instancia = fuente.new
           else
             instancia = fuente.clone
             origen.target = fuente.singleton_class
           end
      end
=end
      origen.target.singleton_class.send(:attr_accessor, :origen)
      origen.target.origen = origen

      comportamiento = proc do
        if self.class.methods.include? :origen
          self.class.origen
        else
          self.origen
        end
      end

      origen.target.send(:define_method, :origen, &comportamiento)

      origen.instance_eval &bloque

    end

  end

  def self.regexp_to_origins(regexp)
    Object.constants.grep(regexp) {|s|Object.const_get s}
  end

  def self.select_origins(*parametros)
    if parametros.empty?
      raise ArgumentError.new 'wrong number of arguments (0 for +1)'
    end

    origins = parametros.flat_map {|posible_origen| (posible_origen.is_a?(Regexp)) ? (self.regexp_to_origins posible_origen) : [posible_origen]}
    origins.empty? ? (raise ArgumentError.new 'Origen vacio') : origins.uniq
  end

end

class God
end
=begin
class Ejecutador
  attr_accessor :metodo, :fuente

  def initialize(metodo, fuente)
    self.metodo = metodo
    self.fuente = fuente
  end

  def method_missing(sym, *args)
    if sym == self.metodo.name
      instancia = (self.fuente.instance_of? Class or self.fuente.instance_of? Module) ? fuente.new : fuente
      self.metodo.bind(instancia).call(*args)
    end
  end
end
=end