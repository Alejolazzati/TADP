require 'rspec'
require_relative '../src/aspect'

#estructuras para testear

class Moto
end

class Auto
end

module M
end

describe 'Testeo que el mensaje on funcione para instancias, clases, modulos y expresiones regulares' do

  let(:arreglo) {
    Array.new
  }

  it 'Cualquier instancia de Array deberia entender el mensaje nuevo_metodo' do

      Aspect.on Auto {where}
      expect(Auto.instance_methods.include? :nuevo_metodo).to eq(true)

  end


end









