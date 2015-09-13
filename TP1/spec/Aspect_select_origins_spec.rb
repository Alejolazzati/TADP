require 'rspec'
require_relative '../src/aspect'

#estructuras para testear
class Pepita_test

end

class Pepe_test

end

module ModuleA_test

end

module ModuleB_test

end

pepita_test = Pepita_test.new
pepe_test = Pepe_test.new


describe 'Test basicos de Aspect con clases, modules y instancias por separado' do

  it 'deberia lanzar excepcion cuando no se le pasa parametros' do

    expect { Aspect.select_origins }.to raise_error(ArgumentError, 'wrong number of arguments (0 for +1)')
  end

  it 'deberia devolver las clases cuando le mando solo clases' do

    expect(Aspect.select_origins(Pepe_test, Pepita_test)).to contain_exactly(Pepe_test, Pepita_test)
  end

  it 'deberia devolver mixins cuando le mando solo mixins' do

    expect(Aspect.select_origins(ModuleA_test, ModuleB_test)).to contain_exactly(ModuleA_test, ModuleB_test)
  end

  it 'deberia devolver unos objetos cuando le mando solo unos objetos' do

    expect(Aspect.select_origins(pepita_test, pepe_test)).to contain_exactly(pepita_test, pepe_test)
  end


  describe 'Test basicos de Aspect con Expresiones Regulares matcheando con clases, modules y instancias por separado' do

    it 'deberia devolver las clases que matchean con la regex' do

      expect(Aspect.select_origins(/Pepita_test|Pepe_test/)).to contain_exactly(Pepita_test, Pepe_test)
    end

    it 'deberia devolver mixins que matchean con la regex' do

      expect(Aspect.select_origins(/A_test|B_test/)).to contain_exactly(ModuleA_test, ModuleB_test)
    end


    it 'deberia devolver la lista vacia ya que los objetos concretos no matchean con la regex' do

      expect{Aspect.select_origins(/objeto_que_no_existe/)}.to raise_error(ArgumentError, 'Origen vacio')
    end

  end


  describe 'Test de Aspect con Expresiones Regulares, clases, modules y instancias' do

    it 'regex no encontrada retorna origins vacio' do

      expect{Aspect.select_origins(/Regex no existente/)}.to raise_error(ArgumentError, 'Origen vacio')
    end

    it 'deberia devolver las clases, modulos, objetos explicitos y clases y modulos implicitamente con la regex' do

      expect(Aspect.select_origins(Pepita_test, ModuleA_test, pepe_test, /Pepe_test/, /B_test/)).to contain_exactly(Pepita_test, ModuleA_test, pepe_test, Pepe_test, ModuleB_test)
    end

    it 'implicitos y explicitos y ademas una Regex que no encuentra nada' do

      expect(Aspect.select_origins(Pepita_test, ModuleA_test, pepe_test, /Pepe_test/, /B_test/)).to contain_exactly(Pepita_test, ModuleA_test, pepe_test, Pepe_test, ModuleB_test)
    end

  end


end