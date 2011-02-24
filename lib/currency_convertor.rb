require "net/http"
require "net/https"
require "money"
require "uri"
require "json"

class Money
  module Bank
   class CurrencyConvertor
     URL = "http://www.google.com/".freeze
     attr_accessor :from,:to,:amount
     def initialize(amount,from,to="USD")
       @from = from
       @to = to
       @amount = amount
       @url = URI.parse "#{URL}"
     end

     def convert
       url = URI.parse "#{@url}"
       http = Net::HTTP.new(url.host,url.port)
       path = "/ig/calculator?hl=en&q=#{amount.to_s}#{from}%3D%3F#{to}"
       json_data = json_format(http.get(path).body)
       error =  json_data['error']
       raise UnknownRate unless error == '' || error == '0'
       json_data['rhs']
     end


  private
    def json_format(data)
      data.gsub!(/lhs:/, '"lhs":')
      data.gsub!(/rhs:/, '"rhs":')
      data.gsub!(/error:/, '"error":')
      data.gsub!(/icc:/, '"icc":')
      JSON.parse(data)
   end

  end
 end
end

