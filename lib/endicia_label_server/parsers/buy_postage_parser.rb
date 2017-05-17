module EndiciaLabelServer
  module Parsers
    class BuyPostageParser < ParserBase
      attr_accessor :postage_balance, :ascending_balance, :account_status, :transaction_id

      def value(value)
        super

        string_value = value.as_s
        if switch_active? :CertifiedIntermediary
          if switch_active? :PostageBalance
            self.postage_balance = string_value
          elsif switch_active? :AscendingBalance
            self.ascending_balance = string_value
          elsif switch_active? :AccountStatus
            self.account_status = string_value
          end
        elsif switch_active? :TransactionID
          self.transaction_id = string_value
        end
      end
    end
  end
end