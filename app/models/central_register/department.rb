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
      response.xpath("//department").map {|node| parse(node)}
    end

    private
    # helpers

    # corrects program from node
    def self.parse(node)
      result = {}
      %w(name name_english short_name code faculty_id faculty_code department_type_id).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end

  end
end

