require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  describe '.switch_source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source

      lead
    end
    let(:source) do
      source = OpenStruct.new
      source.name = 'FSales'

      source
    end

    let(:switch_source) { described_class.switch_source(lead) }

    it 'returns Source Name - Focal source' do
      stub_const('Lead', class_double('Lead', count: 0))
      expect(switch_source).to eq("#{source.name} - Focal")
    end

    it 'returns Source Name - Lopes source' do
      stub_const('Lead', class_double('Lead', count: 1))
      expect(switch_source).to eq("#{source.name} - Lopes")
    end
  end
end
