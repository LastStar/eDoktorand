class SubjectApi < ActionWebService::API::Base
class SubjectHash < ActionWebService::Struct
  member :subject_id, :int
  member :code, :string
  member :label, :string
  member :labelEn, :string
  member :idPerson, :int
  member :idDepartment, :int
end

  api_method :get_subjects,
             :returns => [[SOAP::Mapping]]
end
