require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Country do
  it "returns qualif code for country code" do
    Country.qualified_code('Česká republika').should == '203'
    Country.qualified_code('Velká Británie').should == '826'
  end
end

