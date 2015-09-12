module Transformacion

  def before(&logic)
    self.premethods << logic
  end
  def after(&logic)
    self.postmethods << logic
  end
  def instead_of(&logic)
    self.core_method=logic
  end
  def redirect_to(otro)
    self.metodos.each{ |unMetodo| target.define_method(unMetodo,proc {
                                                        |*args|
                                                      
                                                      otro.send(unMetodo,args)

                                                    })}
    self.core_method=target.origin_method(name)
    self.method=target.origin_method(name)
  end
  def inject(*hasht)
    self.metodos.each{
      |unMetodo|
      old =instance_method(unMetodo)
      target.define_method(unMetodo,proc {
                             |*args|
                             hasht.each{|key,value| args[key]=value}
                             old.bind(taget).call(args)

                                   })

    }
  end

  def transformar_posta
    target = self.target
    premethods = self.premethods
    postmethods = self.postmethods
    core_method = self.core_method
    parameters = self.parameters
    injected_parameters = self.injected_parameters

    self.fuente.send(:define_method,core_method){
        |*args|
      #hacer la magia
    }
  end


end