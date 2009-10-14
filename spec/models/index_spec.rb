require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  it "should return continues based on coridor study length" do
    i = Index.new
    i.enrolled_on = 3.years.ago
    c = Factory(:coridor, :study_length => 4)
    i.coridor = c
    i.continues?.should be_false
    i.status.should == I18n::t(:message_15, :scope => [:txt, :model, :index])
    i = Index.new
    i.enrolled_on = 3.years.ago
    c = Factory(:coridor, :study_length => 3)
    i.coridor = c
    i.continues?.should be_true
    i.status.should == I18n::t(:message_14, :scope => [:txt, :model, :index])
  end
end

