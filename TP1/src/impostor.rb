class Impostor

  attr_accessor :origen

  def initialize(origen)
    @origen = origen
  end

  def where(*condiciones)
    condiciones.each {|unaCondicion|}
  end

end