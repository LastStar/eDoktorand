require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Approval do
  before(:each){@approval = Approval.new}
  it "should return last approver" do
    @approval.last_approver.should be_nil
    @approval.tutor_statement = TutorStatement.make(:person => Tutor.make)
    @approval.last_approver.should equal Tutor
    @approval.leader_statement = LeaderStatement.make(:person => Tutor.make)
    @approval.last_approver.should equal Leader
    @approval.dean_statement = DeanStatement.make(:person => Tutor.make)
    @approval.last_approver.should equal Dean
  end
  context "on study plan"  do
    before(:each) do
      @study_plan = StudyPlan.make
      @approval = StudyPlanApproval.new(:study_plan => @study_plan)
      @faculty = @study_plan.index.faculty
      @tutor = @study_plan.index.tutor
      @leader = Leader.make(:leadership => Leadership.make(:department => @study_plan.index.department))
      @dean = Dean.make
      @dean.deanship = Deanship.make(:faculty => @faculty, :dean => @dean)
      @faculty_secretary = FacultySecretary.make
      @faculty_secretary.faculty_employment = FacultyEmployment.make(:faculty => @faculty)
    end
    it "should return if waits for tutor statement from person" do
      @approval.should be_waiting_for_tutor_statement(@tutor)
    end
    it "should return if waits for leader statement from person" do
      @approval.should_not be_waiting_for_leader_statement(@leader)
      @approval.index.tutor = @leader
      @approval.should be_waiting_for_leader_statement(@leader)
      @approval.index.tutor = @tutor
      @approval.tutor_statement = TutorStatement.make(:person => @tutor)
      @approval.should be_waiting_for_leader_statement(@leader)
    end
    it "should return if waits for dean statement from person" do
      @approval.index.tutor = @leader
      @approval.should_not be_waiting_for_dean_statement(@dean)
      @approval.leader_statement = LeaderStatement.make(:person => @leader)
      @approval.should be_waiting_for_dean_statement(@dean)
    end
    it "should return if prepare statement" do
      @approval.should be_prepares_statement(@faculty_secretary)
      @approval.should be_prepares_statement(@tutor)
      @approval.tutor_statement = TutorStatement.make(:person => @tutor)
      @approval.should_not be_prepares_statement(@tutor)
      @approval.should be_prepares_statement(@leader)
      @approval.leader_statement = LeaderStatement.make(:person => @leader)
      @approval.should_not be_prepares_statement(@leader)
      @approval.should be_prepares_statement(@dean)
      @approval.dean_statement = DeanStatement.make(:person => @dean)
      @approval.should_not be_prepares_statement(@dean)
    end
    it "should return document it approves" do
      @approval.document.should equal @study_plan
    end
    it "should return index of study plan it approves" do
      @approval.index.should == @study_plan.index
    end
    it "should return statement for person"
  end
  context "on dissertation" do
    before(:each) do
      @dissertation = DisertTheme.make
      @approval = DisertThemeApproval.new(:disert_theme => @dissertation)
    end
    it "should return document it approves" do
      @approval.document.should equal @dissertation
    end
    it "should return index of dissertation it approves" do
      @approval.index.should == @dissertation.index
    end
  end
  context "on study interrupt" do
    before(:each) do
      @study_interrupt = StudyInterrupt.make
      @approval = StudyInterruptApproval.new(:interrupt => @study_interrupt)
    end
    it "should return document it approves" do
      @approval.document.should equal @study_interrupt
    end
    it "should return index of dissertation it approves" do
      @approval.index.should == @study_interrupt.index
    end
  end
  context "on final exam" do
    before(:each) do
      @index = Index.make
      @approval = FinalExamApproval.new(:index => @index)
    end
    it "should return document it approves" do
      @approval.document.should equal @index
    end
  end
end

