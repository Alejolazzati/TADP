require 'rspec'
require_relative '../src/aspect'
require_relative '../src/origen'
require_relative '../src/transformacion'

#estructuras para testear

describe 'Test de transformaciones "integradoras"' do
  before(:each) do
    class A
      def saludar(x)
        "Hola, " + x
      end
    end

    class Suma
      def sumar(a, b)
        a + b
      end
    end

    class B
      def saludar(x)
        "Adiosin, " + x
      end
    end

    class MiClase
      attr_accessor :x

      def m1(x, y)
        x + y
      end

      def m2(x)
        @x = x
      end

      def m3(x)
        @x = x
      end

      def hace_algo(p1, p2)
        p1 + '-' + p2
      end

      def hace_otra_cosa(p2, ppp)
        p2 + ':' + ppp
      end
    end
    class Golondrina
      attr_accessor :sarasa

      def initialize(p)
        @sarasa = p
      end

      def sarlompa(p1)
        @sarasa
      end
    end

  end
  let (:instancia) do
    instancia = MiClase.new
  end

  it 'test de juan' do
    Aspect.on Golondrina do
      transform(where name(/sarlompa/)) do
        inject(p1: 'bar')
      end
    end
    expect(Golondrina.new(5).sarlompa(7)).to eq(5)
    expect(Golondrina.new(10).sarlompa(4)).to eq(10)
  end

  it 'redireccionar saludo' do
    Aspect.on A do
      transform(where name(/saludar/)) do
        redirect_to(B.new)
      end
    end

    expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")
  end


  it 'instead of' do
    Aspect.on MiClase do
      transform(where name(/m3/)) do
        instead_of do |instance, *args|
          @x = 123
        end
      end
    end

    expect(MiClase.new.m3(10)).to eq(123)
    instancia.m3(10)
    expect(instancia.x).to eq(123)
  end


  it 'after' do
    Aspect.on MiClase do
      transform(where name(/m2/)) do
        after do |instance, *args|
          if @x > 100
            2 * @x
          else
            @x
          end
        end
      end
    end

    expect(instancia.m2(10)).to eq(10)
    expect(instancia.m2(200)).to eq(400)
  end

  it 'before' do
    Aspect.on MiClase do
      transform(where name(/m1/)) do
        before do |instance, cont, *args|
          @x = 10
          new_args = args.map { |arg| arg * 10 }
          cont.call(self, nil, *new_args)
        end
      end
    end
    expect(instancia.m1(1, 2)).to eq(30)
    expect(instancia.x).to eq(10)

  end

  it 'inject' do
    Aspect.on MiClase do
      transform(where name(/hace_*/)) do
        inject(p2: 'bar')
      end
    end
    expect(instancia.hace_algo("foo")).to eq("foo-bar") #deberia poder recibir un param menos?
    expect(instancia.hace_algo("foo", "foo")).to eq("foo-bar")
    expect(instancia.hace_otra_cosa("foo", "foo")).to eq("bar:foo")
  end

  it 'Lanza excepcion cuando se le pasa un parametro que no existe' do
    expect {
      Aspect.on MiClase do
        transform(where name(/m2/)) do
          inject(asdd: 42)
        end
      end
    }.to raise_error(ArgumentError, 'Ese parametro no existe PAPA!')
  end

  it 'inject con proc basico' do
    Aspect.on MiClase do
      transform(where name(/m3/)) do
        inject(x: proc { |receptor, mensaje, arg_anterior| 5 })
      end
    end
    expect(instancia.m3(15)).to eq(5)
  end

  it 'inject con proc basico con parametro anterior' do
    Aspect.on MiClase do
      transform(where name(/m3/)) do
        inject(x: proc { |receptor, mensaje, arg_anterior| 5 +  p(arg_anterior)})
      end
    end
    expect(instancia.m3(15)).to eq(20)
  end

  it 'transformacion compuesta del enunciado' do
    Aspect.on B do
      transform(where name(/saludar/)) do
        inject(x: "Tarola")
        redirect_to(A.new)
      end
    end
    expect(B.new.saludar("Mundo")).to eq("Hola, Tarola")
  end

  it 'inject con 2 parametros' do
    Aspect.on Suma do
      transform(where name(/sumar/)) do#probar con has_parameters(1, /b/) TODO
        inject(a: 100, b: 50)
      end
    end

    expect(Suma.new.sumar(1, 2)).to eq(150)
    expect(Suma.new.sumar(100, 100)).to eq(150)
    expect(Suma.new.sumar(2, 1)).to eq(150)
  end

end