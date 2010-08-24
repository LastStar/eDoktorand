require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  it "returns qualif code for country code" do
    Country.qualified_code('CZ').should == '203'
    Country.qualified_code('GB').should == '826'
  end
end

