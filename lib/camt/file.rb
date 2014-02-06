module Camt
  class File
    attr_accessor :code, :country_code, :name
    attr_accessor :doc, :ns

    def self.parse file
      Camt::File.new Nokogiri::XML ::File.read(file)
    end

    def initialize doc, options = { code: 'CAMT', country_code: 'NL', name: 'Generic CAMT Format' }
      self.code = options[:code] || 'CAMT'
      self.country_code = options[:country_code] || 'NL'
      self.name = options[:name] || 'Generic CAMT Format'

      self.doc = doc
      self.ns = doc.namespaces['xmlns']

      check_version
    end


    def check_version
      # Sanity check the document's namespace
      raise 'This does not seem to be a CAMT format bank statement' unless ns.start_with?('urn:iso:std:iso:20022:tech:xsd:camt.')
      raise 'Only CAMT.053 is supported at the moment.' unless ns.start_with?('urn:iso:std:iso:20022:tech:xsd:camt.053.')
      return true
    end

    def messages
      @messages ||= Parser.new.parse doc
    end

    def statements
      @statements ||= messages.map(&:statements).flatten
    end

    def transactions
      @transactions ||= statements.map(&:transactions).flatten
    end


    def to_s
      "#{name}: #{messages.map{|message| message.group_header.message_id }.join(', ')}"
    end

  end
end