require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Employee do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:employees_response xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <employees>
    <employee>
      <uic>50005</uic>
      <personal_number>1272</personal_number>
      <first_name>Jaroslav</first_name>
      <last_name>Weiser</last_name>
      <birth_name>Weiser</birth_name>
      <basic_employment_number>1</basic_employment_number>
      <title_before>RNDr.</title_before>
      <title_after>DrSc.</title_after>
      <mail>weiser@fld.czu.cz</mail>
      <phone_line>3726</phone_line>
      <department_code>43150</department_code>
    </employee>
  </employees>
</soap:employees_response>
BODY
    end
    it "it returns array of employee hash" do
      CentralRegister::Employee.find(50005).should ==
        {:uic => '50005',
        :first_name => 'Jaroslav',
        :last_name => 'Weiser',
        :birth_name => 'Weiser',
        :title_before => 'RNDr.',
        :title_after => 'DrSc.',
        :mail => "weiser@fld.czu.cz",
        :phone_line => '3726',
        :department_code => '43150',}
    end
  end
end







