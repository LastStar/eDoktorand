require_gem "SimpleSearch"

class ActiveRecord::Base

    def self.make_searchable(list_of_field_symbols)
        @searchable_fields = list_of_field_symbols
    end

    def self.searchable_fields
        @searchable_fields
    end

end

class MockContents
    def latest_mtime
        Time.at(0)
    end
end

