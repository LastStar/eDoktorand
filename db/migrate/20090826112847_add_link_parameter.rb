class AddLinkParameter < ActiveRecord::Migration
  def self.up
    add_column :parameters, :link, :string
    parameters = Parameter.find(:all)
    for parameter in parameters do
      case parameter.name
      when "enroll_invitation_time_and_place"
        parameter.update_attribute(:link,"confirm_admit_prewiev.rhtml")
      when "start_stipendia"
        parameter.update_attribute(:link,"confirm_admit_prewiev.rhtml")
      when "methodics_term"
        parameter.update_attribute(:link,"confirm_admit_prewiev.rhtml")

        
      end
    end  
  end

  def self.down
     remove_column :parameters, :link
  end
end
