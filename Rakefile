require 'rubygems'
gem 'rcodetools'
gem 'maruku', '>= 0.6.0'

def file_list
  files = File.read("content/toc").split("\n")
  files.collect! {|file| file.downcase.downcase.gsub(/[\W ]/,"_") }
  files.collect! {|file| File.join("content", "#{file}.md")}
  files = files.select do |file|
    if File.exists? file
      true
    else
      puts "WARNING: file #{file} does not exist!"
      false
    end
  end
end

def run(cmd)
  puts "=> #{cmd}"
  system(cmd) || raise("command failed: #{cmd}")
end

def sub_inline_docs!(content)
  content.gsub!(/^~~~ inline (.*)/) do |match|
    file = "content/#{$1}"
    raise "Could not find asset #{file}" unless File.exists?(file)
    puts "inline file: #{file}"

    ("# #{File.basename(file)}\n" + File.read(file)).gsub!(/^/,'    ')
  end
end

def sub_inline_ruby!(content)
  content.gsub!(/^~~~ ruby (.*)/) do |match|
    file = "content/#{$1}"
    raise "Could not find asset #{file}" unless File.exists?(file)
    puts "ruby file: #{file}"

    out = IO.popen("xmpfilter -a --cd content/assets/ #{file}", "r").read
    out.gsub!(/^.*:startdoc:[^\n]*/m, '') if out =~ /:startdoc:/
    out.gsub!(/\\n/,"\n")
    out.gsub!(/^/,'    ').chomp!
  end
end

task :default => :html

desc "Compile an html version of the book"
task :html do
  STDOUT.sync = true
  files = file_list

  content = files.collect do |file|
    puts file
    File.read(file)
  end.join("\n")
  sub_inline_docs! content
  sub_inline_ruby! content
  IO.popen("maruku > nokogiri-cookbook.html", "w") do |f|
    f.write content
  end
  puts
end
