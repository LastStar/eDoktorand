# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Subject < Handsoap::Service
    endpoint GET_SUBJECT_SERVICE_ENDPOINT
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
      response = invoke('tns:getSubjects')
      response.xpath("//subject").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects program from node
    def self.parse(node)
      result = {}
      %w(code label labelEn uic department).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end

  end
end

