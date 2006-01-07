module FormHelper

  # prints select for departments
  def department_select(faculty)
    content_tag('select', department_options(:faculty => faculty))
  end

  # prints select for languages
  def language_select
    content_tag('select', language_options)
  end
end
