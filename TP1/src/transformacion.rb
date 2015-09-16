module Transformacion

  def before(&logic)
    target.define_method(real_method,proc{|args|
                                      logic.bind(target).call(target,alias_method,args)})
  end

  def after(&logic)

  target.define_method(real_method,proc{|args| alias_method.bind(target).call(args)
                                  logic.bind(target).call(target,args)})
  end

  def instead_of(&logic)
    target.define_method(real_method,proc{|args|
                                    logic.bind(target).call(target,args)})
  end

  def redirect_to(objetivo)
    target.define_method(real_method,proc {|args| objetivo.send(self.real_method)})
  end

  def inject(*hashes)

    Origen.claves = hashes.map{|un_hash| un_hash.keys}.flatten
    Origen.valores = hashes.map{|un_hash| un_hash.values}.flatten
    Origen.parametros = target.instance_method(self.metodo_original).parameters.map{|p| p.last}

    bloque =  proc do
      |*argumentos|

      Origen.claves.each do
        |una_clave|

        posicion = Origen.parametros.index una_clave
        argumentos[posicion] = Origen.valores[posicion]

      end

      super(*argumentos)
   end

    self.target.send(:define_method, self.metodo_original, &bloque)
  end
end




