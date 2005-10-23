module ActiveRecord
  module Acts #:nodoc:
    module Audited #:nodoc:
      
      def self.append_features(base)
        super
        base.extend(ClassMethods)
      end

      # The current user used for the before_save filter to set the +created_by+
      # and +updated_by+ relations
      @@current_user ||= nil
      def self.current_user; @@current_user end
      def self.current_user=(user); @@current_user = user end

      # This act provides the capability for the record being audited, which means
      # saving the user who created and/or last updated the record.
      # It adds +belongs_to+ relationships to the model that represents the user.
      # This relationships are +created_by+ and +updated_by+.
      # The current user for the record is set thru a +before_save+ filter and it gets the
      # current user from +ActiveRecord::Acts::Audited::current_user+ attribute.
      # So, usually, a +before_filter+ in the controller should set this +current_user+
      # attribute accordingly.
      module ClassMethods

        # Configuration options:
        # * +created_by_column+ - specifies the column in the db table that holds 
        #   the creator (default: created_by_id).
        # * +updated_by_column+ - specifies the column in the db table that holds 
        #   the last updater (default: updated_by_id).
        # * +user_model+ - specifies the model that represents users (default: user)
        def acts_as_audited(options = {})
          configuration = { :created_by_column => "created_by_id",
                            :updated_by_column => "updated_by_id",
                            :user_model => "user" }
          configuration.update(options) if options.is_a? Hash

          class_eval do
            include ActiveRecord::Acts::Audited::InstanceMethods
            before_save :set_current_user
            
            if columns_hash.keys.include?(configuration[:created_by_column])
              belongs_to :created_by, 
                         :class_name => configuration[:user_model].to_s.classify, 
                         :foreign_key => configuration[:created_by_column]
            end
                       
            if columns_hash.keys.include?(configuration[:updated_by_column])
              belongs_to :updated_by, 
                         :class_name => configuration[:user_model].to_s.classify, 
                         :foreign_key => configuration[:updated_by_column]
            end
          end
        end
        
      end

      module InstanceMethods

        def set_current_user
          self.created_by = ActiveRecord::Acts::Audited.current_user if @new_record && respond_to?(:created_by)
          self.updated_by = ActiveRecord::Acts::Audited.current_user if respond_to?(:updated_by)
        end
        
      end
      
    end #Audited
  end #Acts
end #ActiveRecord