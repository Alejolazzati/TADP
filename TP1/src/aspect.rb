class Aspect

  def self.on (*parametros, &bloque)
    fuentes = select_origins(*parametros)
    fuentes.each do
      |fuente|

      origen = Origen.new()
      origen.fuente = fuente

      origen.target.singleton_class.send(:attr_accessor, :origen)
      origen.target.origen = origen

      comportamiento = proc do

        ancestros = self.class.ancestors.select{|un_padre| un_padre.respond_to? :origen}
        ancestros << self.singleton_class

        ancestros.flatten.first.send(:origen)

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
