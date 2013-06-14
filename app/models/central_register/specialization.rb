# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Specialization < Handsoap::Service
    endpoint Services::UNIVERSITY_REGISTER
    def on_create_document(doc)
      # register namespaces for the request
      doc.alias 'tns', 'http://culsServices.services'
    end

    def on_response_document(doc)
      # register namespaces for the response
      doc.add_namespace 'ns', 'http://culsServices.services'
    end

    # public methods

    def self.all
      response = invoke('tns:getSpecializations')
      response.xpath("//oboryList/specialization").map do |node|
        parse(node)
      end.uniq.compact
    end

    private
    # helpers

    # corrects subject from node
    def self.parse(node)
      result = {}
      if string_attr(node, "qualificationCode") == "D"
        %w(nameCz nameEn shortName msmtCode language).each do |name|
          result[name.to_sym] = string_attr(node, name)
        end
        return result
      end
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip).to_s
    end
  end
end

