
# se que esto que hago aca ahora se puede diseñar mucho mejor.
# es solo para ver como hacerlo andar e ir probando cosas

module A
  def where
    'FUNQUE AMEEEOO!! EAEAEAEA AGUANTE LAS PUTAS EAEA'
  end
end

# Al definir el metodo en Module, por herencia lo tiene Class
# => no es necesario porner el metodo definir_aspecto en Class, ya lo va a tener
# en Object si (hace otra cosa), Module hereda de este y el mismo redefine el metodo en cuestion.
# igualmente esto es solo para probar que ande. No es necesario este metodo en particular
class Module
  def definir_aspecto(bloque)
    self.send(:define_method, :nuevo_metodo, bloque)
  end
end

class Objectc
  def definir_aspecto (bloque)
    self.singleton_class.send(:define_method, :nuevo_metodo, bloque)
  end
end