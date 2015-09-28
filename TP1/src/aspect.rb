class Aspect
  attr_accessor :origenes

  def self.on (*parametros,&bloquesin)
    fuentes = select_origins(*parametros)
    fuentes.flat_map {|fuente| Origen.new(fuente).instance_eval &bloquesin}

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
