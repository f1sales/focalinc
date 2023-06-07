require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when came from the website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'teste@lojateste.f1sales.net']
      email.subject = 'Um novo Imóvel foi solicitado através do site'
      email.body = "Olá,\n\nUm novo imóvel foi solicitado por um cliente no site FocalInc, acesse o\nadministrativo do site para ter mais informações.\nDados do contato\n------------------------------\n\n\n*PROJETO:*\nArtur 73\n\n*CLIENTE:*\nJoao\n\n*EMAIL:*\njoaocreste@gmail.com\n\n*TELEFONE:*\n(11) 9752-75547\n\n*COMENTÁRIO DO CLIENTE:*\nOlá. Gostaria de mais informações (fotos, plantas) desse projeto. Tenho interesse para investimento ou até mesmo para morar.\n------------------------------\n\nUm abraço!\n\n*Equipe Focal Inc*\n\nFocal Inc <http://Focal%20Inc>"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Joao')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('(11) 9752-75547')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('joaocreste@gmail.com')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:name]).to eq('')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Olá. Gostaria de mais informações (fotos, plantas) desse projeto. Tenho interesse para investimento ou até mesmo para morar.')
    end
  end
end
