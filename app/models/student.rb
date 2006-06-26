class Student < Person
  has_one :index
  has_one :address, :conditions => 'address_type_id = 1'
  has_one :postal_address, :class_name => 'Address', :conditions => 'address_type_id = 2'
  has_one :candidate
  has_and_belongs_to_many :probation_terms

  # returns faculty on which student is
  def faculty
    index.faculty
  end


  #returns display name for printing
  def display_name
    "#{lastname} #{firstname}"
  end

  # retunrs account for printing
  def account
    i = self.index
    if i.account_number_prefix && i.account_number_prefix != ""
      "#{self.index.account_number_prefix}-#{self.index.account_number}/#{self.index.account_bank_number}"
    elsif i.account_number && i.account_number != ""
      "#{self.index.account_number}/#{self.index.account_bank_number}"
    else
      ''
    end
  end

  def coridor
    index.coridor
  end

  def address_or_new
    return address if address
    Address.new_habitat_for(id)
  end
end 
