module Transformacion

  def before(&logic)
    self.metodos.each{|real_method|

      target.send(:alias_method,:old,real_method)



      target.send(:define_method,real_method,proc{|*args|

                                      logic.call(self, self.method(:old),*args)})
    }
  end

  def after(&logic)

    self.metodos.each{|real_method|

      target.send(:alias_method,('0ld'+(target.send(:__cont__).to_s)).to_sym,real_method)
      target.send(:define_method,real_method,proc{|args|
                               self.send(('0ld'+(self.class.send(:__cont__).to_s)).to_sym,args)
                                logic.call(self,args)})
    }
    numero=(target.send(:__cont__))+1
    target.send(:__cont__=,numero)
  end

end

  def instead_of(&logic)
    self.metodos.each{|real_method|
   target.send(:define_method,real_method,proc{|*args|
                                  logic.call(self,*args)})
    }
  end

  def redirect_to(objetivo)
    self.metodos.each{|real_method|
    target.send(:define_method,real_method,proc {|*args| objetivo.send(real_method,*args)})
    }
    end

  def inject(*hash)
    self.metodos.each{|real_method|
    nuevos_parametros = get_nuevos_parametros(hash,real_method);
   target.send(:alias_method,real_method,alias_method)
    target.send(:define_method,real_method,proc{
                  target.send(alias_method,nuevos_parametros)
                              })
    }
    end

  def get_nuevos_parametros(*hash,unMetodo)
    viejos_parametros = target.instance_method(unMetodo).parameters
    hash.each {|hash|self.set_hash(hash,viejos_parametros) }
  end

#hash [(key,value)]
#viejos_parametros [(mode,key)]

  def set_hash(hash,array)

  end
  #holita.method(:m).parameters .index(holita.method(:m).parameters.find { |l,sim| sim == :p2 })

#end