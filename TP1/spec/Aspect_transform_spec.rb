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

class Suma
  def sum a,b
    a+b
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

describe 'Test sobre la clase Suma, invocando al metodo sum con el primer parametro en 1' do

  let(:origen) {
    Origen.new(Suma)
  }

  it 'Al inyectar 100 al segundo parametro del metodo sum, la cuenta deberia dar 101' do

    bloque = proc do
      transform(where has_parameter(1, /b/)) do
        inject(b: 100)
      end
    end

    aspect = origen.instance_eval &bloque

    aspect.instance_eval &bloque

    expect(origen.sum(1,2)).to eq(101)
  end

end