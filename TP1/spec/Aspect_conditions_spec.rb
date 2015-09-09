require 'rspec'
require_relative '../src/Aspect'

#estructuras para testear
class Pepita_test
  include A

  def saludar
    'hola, estoy saludando'
  end
  def paludar
    'paludar'
  end
  def matar
    'te mato'
  end
end

class Pepe_test
  include A

  def matar
    'te mata feo'
  end

  private
  def metodo_privado
    'soy privado'
  end
end

module ModuleA_test

end

module ModuleB_test

end

pepita_test = Pepita_test.new
pepe_test = Pepe_test.new

describe 'Test donde se verifica que las distintas condiciones validen correctamente' do

  it 'name con regEx /.aludar/ deberia ser true para metodos :saludar y :paludar' do
    expect(pepita_test.name(/.aludar/).call :saludar).to be true
    expect(pepita_test.name(/.aludar/).call :paludar).to be true
  end

  it 'name con regEx /.aludar/ deberia ser false metodos que tiene o no definidos, que no cumplen' do
    expect(pepita_test.name(/.aludar/).call :asdfgh).to be false
    expect(pepita_test.name(/.aludar/).call :matar).to be false
  end

  it 'name debe encontrar tantos los metodos privados como publicos para matchear' do
    expect(pepe_test.name(/ma.ar/).call :matar).to be true
    expect(pepe_test.name(/metodo_pri.ad./).call :metodo_privado).to be true
  end

  it 'is_public debe dar true solo para los metodos publicos' do
    expect(pepita_test.is_public.call :saludar).to be true
    expect(pepe_test.is_public.call :metodo_privado).to be false
  end

  it 'is_private debe dar true solo para los metodos privados' do
    expect(pepita_test.is_private.call :saludar).to be false
    expect(pepe_test.is_private.call :metodo_privado).to be true
  end

  it 'tanto is_private como is_public deben dar false sobre metodos no definidos' do
    expect(pepita_test.is_private.call :velez).to be false
    expect(pepe_test.is_public.call :metodo).to be false
  end

  it 'neg debe negar la condicion' do
    expect(pepe_test.neg(pepe_test.name(/ma.ar/)).call :metodo_privado).to be true
    expect(pepe_test.neg(pepe_test.name(/metodo_pri.ad./)).call :matar).to be true
  end

  it 'neg da false cuando la condicion evaluada es true' do
    expect(pepe_test.neg(pepe_test.name(/ma.ar/)).call :matar).to be false
    expect(pepe_test.neg(pepe_test.name(/metodo_pri.ad./)).call :metodo_privado).to be false
  end


end