require 'rspec'
require_relative '../src/Aspect'

#estructuras para testear

class Moto
end

class Auto
end

module M
end

arreglo = Array.new

Aspect.on Moto, arreglo, M, /^S/ do
  where
end

describe 'Testeo que el mensaje on funcione para instancias, clases, modulos y expresiones regulares' do

  it 'Cualquier instancia de Moto deberia entender el mensaje nuevo_metodo' do
      expect(Moto.instance_methods.include? :nuevo_metodo).to eq(true)
  end

  it 'La instancia arreglo deberia entender el mensaje nuevo_metodo' do
    expect(arreglo.methods.include? :nuevo_metodo).to eq(true)
  end

  it 'Cualquier instancia de Array no deberia entender el mensaje nuevo_metodo' do
    expect(Array.new.methods.include? :nuevo_metodo).to eq(false)
  end

  it 'Cualquier instancia de String deberia entender el mensaje nuevo_metodo por la regex /^S/' do
    expect(String.instance_methods.include? :nuevo_metodo).to eq(true)
  end

  it 'Cualquier instancia de Auto deberia entender el mensaje nuevo_metodo si incluye el modulo M' do
    Auto.include(M)
    expect(Auto.instance_methods.include? :nuevo_metodo).to eq(true)
  end

end









