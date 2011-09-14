# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Municipality < Handsoap::Service
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
      response = invoke('tns:getMunicipalities')
      response.xpath("//enumeration/item").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects subject from node
    def self.parse(node)
      result = {}
      %w(name code).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end
  end
end

