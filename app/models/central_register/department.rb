# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Department < Handsoap::Service
    endpoint Services::UNIVERSITY_REGISTER
    def on_create_document(doc)
      # register namespaces for the request
      doc.alias 'tns', 'http://osz.services'
    end

    def on_response_document(doc)
      # register namespaces for the response
      doc.add_namespace 'ns', 'http://osz.services'
    end

    # public methods

    def self.all_departments
      soap_action = 'urn:getUtvary'
      response = invoke('tns:getUtvary', soap_action)
      response.xpath("//utvar").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects program from node
    def self.parse(node)
      {
        :name => string_attr(node, "nazev_cz"),
        :name_english => string_attr(node, "nazev_en"),
        :short_name => string_attr(node, "zkratka"),
        :code => string_attr(node, "kodUtvar"),
        :faculty_id => string_attr(node, "idFakulta"),
        :faculty_code => string_attr(node, "kodFakulta"),
        :type_id => string_attr(node, "idTypUtvar")
      }
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end

  end
end

