# -*- coding: utf-8 -*-
require 'test_helper'

# GetUicService.logger = $stdout

class GetUicServiceTest < Test::Unit::TestCase
  
  def test_get_uic_by_birth_num
    result = GetUicService.get_uic_by_birth_num
  end
end
