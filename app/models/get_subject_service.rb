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

  def self.get_subjects
    soap_action = 'urn:getSubjects'
    response = invoke('tns:getSubjects', soap_action)
    response.xpath("//subject").map {|node| parse_subject(node)}
  end

  private
  # helpers

  # corrects subject from node
  def self.parse_subject(node)
    {
      :code => code = node.xpath("code").to_s.strip,
      :label => node.xpath("label").to_s.strip,
      :label_en => node.xpath("labelEn").to_s.try(:strip),
      :department_short_name => node.xpath("depShortcut").to_s
    }
  end
end
