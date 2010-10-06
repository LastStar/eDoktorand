# -*- coding: utf-8 -*-
require 'handsoap'

class GetSubjectService < Handsoap::Service
  endpoint GET_SUBJECT_SERVICE_ENDPOINT
  def on_create_document(doc)
    # register namespaces for the request
    doc.alias 'tns', 'http://services'
  end
  
  def on_response_document(doc)
    # register namespaces for the response
    doc.add_namespace 'ns', 'http://services'
  end
  
  # public methods
  
  def get_subjects
    soap_action = 'urn:getSubjects'
    response = invoke('tns:getSubjects', soap_action) do |message|
      message
      #raise "TODO"
    end
  end
  
  private
  # helpers
  # TODO
end
