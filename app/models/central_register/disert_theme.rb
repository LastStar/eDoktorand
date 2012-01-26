# -*- coding: utf-8 -*-
require 'handsoap'

module CentralRegister
  class DisertTheme < Handsoap::Service
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

    def self.send(hash)
      response = invoke('tns:setVskp') do |message|
        hash.each do |key, value|
          message.add(key.to_s.camelize(:lower), value)
        end
      end
      response.xpath('//thesis').xpath('id').to_s.try(:strip)
    end
  end
end

