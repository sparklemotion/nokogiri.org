maruku_version_string = %x{maruku --version}
unless $?.success?
  raise "ERROR: you need maruku installed to generate the nokogiri cookbook."
end

maruku_version = maruku_version_string.scan(/Maruku (\d+\.\d+\.\d+)/).first.first
unless maruku_version >= "0.6.0"
  raise "ERROR: you need maruku >= 0.6.0 installed to generate the nokogiri cookbook"
end

task :default => :html

desc "Compile an html version of the book"
task :html do
  files = File.read("content/toc").split
  files.collect! {|file| File.join("content", file)}
  cmd = "cat #{files.join(' ')} | maruku > nokogiri-cookbook.html"
  puts cmd
  system cmd
end
