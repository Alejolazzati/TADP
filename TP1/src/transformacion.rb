module Transformacion

  def inject(*hashes)

    nuevo_origen = Origen.new()
    nuevo_origen.origen_padre = self
    nuevo_origen.hashes = hashes

    bloque = proc do
      |*args|

      parametros = self.origen_padre.metodos[__method__].parameters.map {|p| p.last}

      self.hashes.each do
        |hash|

        clave = hash.keys.first
        valor = hash.values.first
        pos = parametros.index clave

        args[pos] = if valor.is_a? Proc
                      valor.call(self.origen_padre.fuente, __method__, args[pos])
                    else
                      valor
                    end
      end

      if fuente != nil
        self.fuente.send(__method__, *args)
      else
        self.origen_padre.metodos[__method__].bind(self.origen_padre.instancia_de_fuente).call(*args)
      end
    end

    nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &bloque)

    self.agregar_origen_para(self.metodo.name, nuevo_origen)

  end
end

def redirect_to(receptor)
  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.receptor = receptor

  bloque = proc do
  |*args|
      self.receptor.send(__method__, *args)
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &bloque)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def before(&logica)

  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.logica = logica

  comportamiento = proc do
  |*args|
    resultado = self.origen_padre.fuente.instance_exec(*args, &self.logica)
    self.origen_padre.metodos[__method__].bind(self.origen_padre.instancia_de_fuente).call(*resultado)
  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &comportamiento)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def after(&logica)

  nuevo_origen = Origen.new
  nuevo_origen.origen_padre = self
  nuevo_origen.logica = logica

  comportamiento = proc do
  |*args|

    bloque = proc do
      |*args|
      self.metodos[__method__].bind(self.instancia_de_fuente).call(*args)
    end

    self.origen_padre.instance_exec(*args, &bloque)
    self.origen_padre.instance_exec(*args, &self.logica)

  end

  nuevo_origen.singleton_class.send(:define_method, self.metodo.name, &comportamiento)

  self.agregar_origen_para(self.metodo.name, nuevo_origen)

end

def instead_of(&logic)
  target.define_method(real_method,proc{|args|
                                    logic.bind(target).call(target,args)})
end

