class SubjectHash < ActionWebService::Struct
  member :subject_id, :int
  member :code, :string
  member :label, :string
  member :labelEn, :string
  member :idPerson, :int
  member :idDepartment, :int
end

class SubjectApi < ActionWebService::API::Base
  api_method :get_subjects,
             :returns => [[SubjectHash]]
end
