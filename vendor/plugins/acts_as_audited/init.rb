require 'acts_as_audited'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Audited)

