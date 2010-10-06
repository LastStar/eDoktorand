# -*- coding: utf-8 -*-
require 'test_helper'

# GetSubjectService.logger = $stdout

class GetSubjectServiceTest < Test::Unit::TestCase
  
  def test_get_subjects
    result = GetSubjectService.get_subjects
  end
end
