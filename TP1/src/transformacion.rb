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

    parametros = target.instance_method(self.metodo_original).parameters.map{|p| p.last}
    metodo = target.instance_method(self.metodo_original)
    claves = hashes.map{|un_hash| un_hash.keys}.flatten
    valores = hashes.map{|un_hash| un_hash.values}.flatten

    self.lista_hashes.concat(hashes)

    bloque =  proc do
      |*argumentos|

      argumentos.each do
        |un_arg|
        if claves.include? un_arg
          argumentos[claves.index un_arg] = valores[claves.index un_arg]
        end
      end

      self.send(self.metodo_original, *argumentos)
   end

    target.send(:define_method, self.metodo_original, &bloque)
  end
end




