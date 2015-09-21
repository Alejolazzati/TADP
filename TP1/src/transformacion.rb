class Transformacion

  def initialize(fuente, metodo_inicial)
    @real_method = @metodo = fuente.instance_method(metodo_inicial)
    @target = fuente
    @inject = {}
    @redirect_to = nil
    @before = nil
    @after = nil
    @instead_of = nil
    @logic = proc { metodo_inicial.clone.send(:bind, self) }
    parametros = []
  end

  def transformate
    yield()


    metodo = @metodo
    real_method = @real_method
    @target.send(:define_method, real_method.name) do
    |*parametros|
      metodo = metodo.bind(self) if metodo.is_a?(UnboundMethod)

      instance_exec(*parametros, &metodo)

    end

  end

  def redirect_to(objetivo)
    real_method = @real_method.name
    @metodo = proc { |*parametros| objetivo.send(real_method, *parametros) }
  end

  def instead_of(&nuevo_metodo)
    @method = proc { |*parametros| instance_exec(self, *parametros, &nuevo_metodo) }
  end




end


=begin
def before(&logic)
  logic.call; self.fuente.send(self.metodo_alias)
end

def after(&logic)
  self.fuente.send(self.metodo_alias); logic.call
end

def instead_of(&logic)
  logic.call
end


def inject(*hash)
  proc { nuevos_parametros = get_nuevos_parametros(hash); self.fuente.send(self.real_method, *nuevos_parametros) }
end

def get_nuevos_parametros(*hash)
  viejos_parametros = self.method(self.real_method).parameters
  hash.each { |un_hash| self.set_hash(un_hash, viejos_parametros) }
end

#hash [(key,value)]
#viejos_parametros [(mode,key)]

def set_hash(hash, array)
end
#holita.method(:m).parameters .index(holita.method(:m).parameters.find { |l,sim| sim == :p2 })
=end