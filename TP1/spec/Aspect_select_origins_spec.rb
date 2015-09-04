require 'rspec'
require_relative '../src/Aspect'

#estructuras para testear
class Pepita_test

end

class Pepe_test

end

module A_test

end

module B_test

end

pepita_test = Pepita_test.new
pepe_test = Pepe_test.new


describe 'Test basicos de Aspect con clases, modules y instancias por separado' do
  let(:expected_origins) {
    Array.new
  }

  it 'deberia lanzar excepcion cuando no se le pasa parametros' do
    expect { Aspect.select_origins() }.to raise_error(ArgumentError, 'wrong number of arguments (0 for +1)')
  end

  it 'deberia devolver las clases cuando le mando solo clases' do
    expected_origins.push(Pepe_test, Pepita_test)

    expect(Aspect.select_origins(Pepe_test, Pepita_test)).to eq(expected_origins)
  end

  it 'deberia devolver mixins cuando le mando solo mixins' do
    expected_origins.push(A_test, B_test)

    expect(Aspect.select_origins(A_test, B_test)).to eq(expected_origins)
  end

  it 'deberia devolver unos objetos cuando le mando solo unos objetos' do
    expected_origins.push(pepita_test, pepe_test)

    expect(Aspect.select_origins(pepita_test, pepe_test)).to eq(expected_origins)
  end


  describe 'Test basicos de Aspect con Expresiones Regulares matcheando con clases, modules y instancias por separado' do
    let(:expected_origins) {
      Array.new
    }

    it 'deberia devolver las clases que matchean con la regex' do
      expected_origins.push(Pepita_test, Pepe_test)

      expect(Aspect.select_origins(/Pepita_test|Pepe_test/)).to eq(expected_origins)
    end

    it 'deberia devolver mixins que matchean con la regex' do
      expected_origins.push(A_test, B_test)

      expect(Aspect.select_origins(/A_test|B_test/)).to eq(expected_origins)
    end

    it 'deberia devolver la lista vacia ya que los objetos concretos no matchean con la regex' do

      expect(Aspect.select_origins(/pepe_test|pepita_test/)).to eq(expected_origins)
    end

  end


  describe 'Test de Aspect con Expresiones Regulares, clases, modules y instancias' do
    let(:expected_origins) {
      Array.new
    }

    it 'regex no encontrada retorna origins vacio' do

      expect(Aspect.select_origins(/Regex no existente/)).to eq(expected_origins)
    end

    it 'deberia devolver las clases, modulos, objetos explicitos y clases y modulos implicitamente con la regex' do
      expected_origins.push(Pepita_test, A_test, pepe_test, Pepe_test, B_test)

      expect(Aspect.select_origins(Pepita_test, A_test, pepe_test, /Pepe_test/, /B_test/)).to eq(expected_origins)
    end

    it 'implicitos y explicitos y ademas una Regex que no encuentra nada' do
      expected_origins.push(Pepita_test, A_test, pepe_test, Pepe_test, B_test)

      expect(Aspect.select_origins(Pepita_test, A_test, pepe_test, /Pepe_test/, /B_test/, /Regex no existente/)).to eq(expected_origins)
    end

  end


end