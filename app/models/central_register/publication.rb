# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Publication < Handsoap::Service
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

    def self.find(uic)
      response = invoke('tns:getPublications') do |message|
        message.add('uic', uic)
      end
      response.xpath("//publicationsList/publication").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects subject from node
    def self.parse(node)
      result = {}
      %w(name name_english authors quotations publication_type_id publication_type cep publication_year).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end
  end
end

