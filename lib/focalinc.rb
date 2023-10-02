# frozen_string_literal: true

require_relative 'focalinc/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'

module Focalinc
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      {
        source: source,
        customer: customer,
        product: product,
        message: message
      }
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{regular_expression}).*?:/, false)
    end

    def regular_expression
      'CLIENTE|EMAIL|TELEFONE|COMENTÁRIO DO CLIENTE|'
    end

    def source
      {
        name: F1SalesCustom::Email::Source.all[0][:name]
      }
    end

    def customer
      {
        name: parsed_email['cliente'],
        phone: parsed_email['telefone'],
        email: parsed_email['email']
      }
    end

    def product
      {
        name: ''
      }
    end

    def message
      parsed_email['comentrio_do_cliente'].split("\n-").first
    end
  end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        return "#{lead_source} - Lopes" if (Lead.count % 3).zero?

        "#{lead_source} - Focal"
      end

      private

      def lead_source
        @lead.source.name
      end
    end
  end
end
