class Approver
  def self.approve_interupts
    Interupt.find(:all).each do |int|
      unless int.approved?
        index = int.index
        int.approvement = InteruptApprovement.new unless int.approvement
        case int.last_approver
        when nil
          int.approve_like('tutor')
          int.approve_like('leader')
        when Tutor
          int.approve_like('leader')
        end
        int.approve_like('dean')
      end
    end
  end
end
