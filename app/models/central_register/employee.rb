# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class Employee < Handsoap::Service
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
      response = invoke('tns:getEmployee') do |message|
        message.add('uic', uic)
      end
      response.xpath("//employees/employee").map {|node| parse(node)}.first
    end

    private
    # helpers

    # corrects subject from node
    def self.parse(node)
      result = {}
      %w(uic first_name last_name birth_name title_before title_after mail phone_line department_code).each do |name|
        result[name.to_sym] = string_attr(node, name)
      end
      return result
    end

    def self.string_attr(node, xpath)
      node.xpath(xpath).to_s.try(:strip)
    end
  end
end


