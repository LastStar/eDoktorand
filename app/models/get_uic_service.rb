# -*- coding: utf-8 -*-
require 'handsoap'

class GetUicService < Handsoap::Service
  endpoint GET_UIC_SERVICE_ENDPOINT
  def on_create_document(doc)
    # register namespaces for the request
    doc.alias 'tns', 'http://services'
  end
  
  def on_response_document(doc)
    # register namespaces for the response
    doc.add_namespace 'ns', 'http://services'
  end
  
  # public methods
  
  def get_uic_by_birth_num(birth_number)
    soap_action = 'urn:getUicByBirthNum'
    response = invoke('tns:getUicByBirthNum', soap_action) do |message|
      message.add 'getUicByBirthNum', birth_number
    end
    response.document.xpath("//uic").to_s
  end
  
  private
  # helpers
  # TODO
end
