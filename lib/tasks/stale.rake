namespace :stale do

  task :helpers do
    stale_for_glob 'app/helpers/*_helper.rb'
  end

  task :actions do
    stale_for_glob 'app/controllers/*_controller.rb'
  end  

  def stale_for_glob(glob)
    Dir[glob].each do |filename|
      File.open(filename) do |file|
        file.each do |line|
         if line =~ /^\s*def\s+([[:alnum:]_]+)/
           meth = $1
           if `grep -R '#{meth}' app vendor/plugins | grep -v svn`.strip.split("\n").size <= 1
             $stderr.puts "#{filename} : #{meth}" 
           end
         end
        end
      end
    end    
  end

end
