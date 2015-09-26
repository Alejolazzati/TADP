require_relative 'condicion'
require_relative 'transformacion'

class Origen

  include Condicion
  include Transformacion

  attr_accessor :metodos ,:fuente,:hashMetodos

  def initialize(fuente)
    @fuente = fuente
    @metodos=Array.new

  end

  def where(*condiciones)
    self.all_methods.select do
      |method|
      condiciones.all? { |condicion| condicion.call(method) }
    end
  end
  def transform(metodos_filtrados, &bloque)
    target.send(:__cont__=,100)

    self.hashMetodos={}

    metodos_filtrados.each do |metodo|
     target.send(:alias_method,('old'+metodo.to_s).to_sym,metodo)
     self.hashMetodos[metodo]=Array.new
      self.hashMetodos[metodo].push &proc {|instance,cont,*args|

        instance.send(('old'+metodo.to_s).to_sym,*args)
                                                        }

    end
    bloque.call()

    hashM=self.hashMetodos
   target.send(:define_method,:__hashMetodos__,proc do
                             hashM
                             end)

   metodos.each do |metodo|


   target.send(:define_method,metodo,proc {
                |*args|
                               ( __hashMetodos__[metodo].inject(proc{}){|cont,proc| proc.curry.(self).(cont)}).call(self,*args)
                             })
   end

  end

  def target
    (fuente.instance_of?(Class) || fuente.instance_of?(Module)) ? fuente : fuente.singleton_class
  end

  def all_methods
    target.private_instance_methods + target.public_instance_methods
  end

  def agregarContinuacion(&bloque)
  proc do |instance, cont, *args|
    instance.instance_exec(*args,&bloque)
    cont.call(instance,*args)

end
    end
end

