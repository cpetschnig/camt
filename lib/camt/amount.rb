module Camt
  class Amount

    attr_reader :node

    def initialize(xml_node)
      @node = xml_node
    end

    def value
      sign * BigDecimal.new(node.at('./Amt').text)
    end

    def sign
      node.at('./CdtDbtInd').text == 'DBIT' ? -1 : 1
    end

    def currency
      node.at('./Amt').attribute('Ccy').value
    end
  end
end
