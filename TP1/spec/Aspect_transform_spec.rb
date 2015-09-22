require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'

describe 'Tests de la transformacion inject sobre el metodo sumar de la clase Suma' do

  it 'Al inyectar 100 al segundo parametro del metodo sum, la cuenta deberia dar 101' do
    class Suma
      def sumar a,b
        a+b
      end
    end

    Aspect.on Suma do
      transform(where has_parameters(1, /b/)) do
        inject(b: 100)
      end
    end

    expect(Suma.new.sumar(1,2)).to eq(101)
  end

  it 'Al inyectar 100 al primer parametro del metodo sum y 50 al segundo, la cuenta deberia dar 150 independientemente de los parametros reales' do
    class Suma
      def sumar a,b
        a+b
      end
    end

    Aspect.on Suma do
      transform(where has_parameters(1, /b/)) do
        inject(b: 50)
        inject(a: 100)
      end
    end

    expect(Suma.new.sumar(1,2)).to eq(150)
    expect(Suma.new.sumar(100,100)).to eq(150)
    expect(Suma.new.sumar(2,1)).to eq(150)
  end

  it 'Al inyectarle un proc al segundo parametro, concatena el primero al resultado del proc: foo con bar(sumar->foo)' do

    class Suma
      def sumar a,b
        a+b
      end
    end


    Aspect.on Suma do
      transform(where has_parameters(1, /b/)) do
        inject(b: proc {|receptor, mensaje, arg_anterior| "bar(#{mensaje}->#{arg_anterior})"})
      end
    end

    expect(Suma.new.sumar('foo', 'foo')).to eq("foobar(sumar->foo)")
  end
end

describe 'Tests sobre la transformacion redirect_to sobre las clases A y B' do

  it 'El metodo saludar de B se lo redirecciona al metodo saludar de A' do
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

  Aspect.on A do
    transform(where name(/saludar/)) do
      redirect_to (B.new)
    end
  end

  expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")

  end
end

describe 'Tests sobre las transformaciones de inyeccion de logica' do

  it 'Transformacion before' do

    class MiClase
      attr_accessor :x

      def m1(x,y)
        x+y
      end
    end

    Aspect.on MiClase do
      transform(where name(/m1/)) do
        before do |*args|
          new_args = args.map{|arg| arg * 10}
          new_args
        end
      end
    end

    instancia = MiClase.new
    expect(instancia.m1(1,2)).to eq(30)
  end

  it 'Transformacion after' do
    class MiClase
      attr_accessor :x

      def m2(x)
        @x = x
      end
    end

    Aspect.on MiClase do
      transform(where name(/m2/)) do
        after do |*args|
          if @x > 10
            2 * @x
          else
            @x
          end
        end
      end
    end

    instancia = MiClase.new
    expect(instancia.m2(10)).to eq(10)
  end

end



