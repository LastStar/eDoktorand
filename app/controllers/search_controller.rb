require_dependency "search_system"

class SearchController < ApplicationController
    layout "search" , :except => [:rss, :description]
    
    def index 
        search
    end

    #-----------------------------------------------------------------------
    # search through the index, get the ActiveRecord's that match and
    # return those to the caller
    #-----------------------------------------------------------------------
    def search
        @search_terms = @params['search_terms'].split
        @count        = @params['count'].to_i || -1
        
        empty_contents = MockContents.new
        simple_index = Search::Simple::Searcher.load(empty_contents,"#{File.dirname(__FILE__)}/../../db/search_cache") 

        # what to return to the caller
        @results = Array.new

        # TODO: sort by score at some point ?
        search_results = simple_index.find_words(@search_terms)

        if search_results.contains_matches then
            search_results.results.sort.each do |result|
                (classname,pk_id,column) = result.name.split(".")
                classvar = eval(classname)
                @results << classvar.find(pk_id)
                break if @count > 0 and @results.size >= @count 
            end
        end

        @results.uniq!
    end

    def description
        @headers["Content-Type"] = "text/xml"
        render 'opensearch/description'
    end
    def rss
        @headers["Content-Type"] = "text/xml"
        search
        render 'opensearch/rss'
    end
end
