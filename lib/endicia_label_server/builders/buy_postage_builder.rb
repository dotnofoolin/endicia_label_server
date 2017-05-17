require 'ox'

module EndiciaLabelServer
  module Builders
    class BuyPostageBuilder < BuilderBase
      include Ox

      def initialize(opts = {})
        super 'RecreditRequest', opts
      end

      def post_field
        'recreditRequestXML'
      end
    end
  end
end