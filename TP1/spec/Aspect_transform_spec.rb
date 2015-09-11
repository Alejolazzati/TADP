require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'

#estructuras para testear
class A
  def saludar(x)
    "Hola, " + x
  end
end

class B
  def saludar(x)
    "Adiosin, " + x
  end
end



describe 'Test de condiciones concretas' do

  let(:origen) {
    Origen.new(A)
  }

  it 'redireccionar saludo' do

    origen.instance_eval {transform :saludar  do
      redirect_to(B.new)
    end
    }
    expect(A.new.saludar("Mundo")).to be_identical_string("Adiosin, Mundo")

  end

end