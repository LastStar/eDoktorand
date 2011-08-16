# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Specialization < Handsoap::Service
    endpoint Services::ERUDIO_REGISTER
    def on_create_document(doc)
      # register namespaces for the request
      doc.alias 'tns', 'http://ciselniky.services'
    end

    def on_response_document(doc)
      # register namespaces for the response
      doc.add_namespace 'ns', 'http://ciselniky.services'
    end

    # public methods

    def self.all
      response = invoke('tns:getObory', 'urn:getObory')
      response.xpath("//specializations/specialization").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects subject from node
    def self.parse(node)
      result = {}
      %w(name name_english code guarantee_uic).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end
  end
end

