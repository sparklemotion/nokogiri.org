require 'rubygems'
gem 'rcodetools'
gem 'maruku', '>= 0.6.0'

def rawmd_directory
  "content"
end

def cookedmd_directory
  "markdown"
end

def html_directory
  "html"
end

def rawmd_file_list
  files = File.read("#{rawmd_directory}/toc").split("\n")
  files.collect! {|file| file.downcase.downcase.gsub(/[\W ]/,"_") }
  files.collect! {|file| File.join(rawmd_directory, "#{file}.md")}
  files = files.select do |file|
    if File.exists? file
      true
    else
      STDERR.puts "WARNING: file #{file} does not exist!"
      false
    end
  end
end

def cookedmd_file_list
  files = File.read("#{rawmd_directory}/toc").split("\n")
  files.collect! {|file| file.downcase.downcase.gsub(/[\W ]/,"_") }
  files.collect! {|file| File.join(cookedmd_directory, "#{file}.md")}
  files = files.select do |file|
    if File.exists? file
      true
    else
      STDERR.puts "WARNING: file #{file} does not exist!"
      false
    end
  end
end

def format_html_filename(markdown_filename)
  File.join(html_directory, File.basename(markdown_filename).gsub(/\.md$/, ".html"))
end

def run(cmd)
  puts "=> #{cmd}"
  system(cmd) || raise("command failed: #{cmd}")
end

def sub_do(tag, content, codetype="", &block)
  content.gsub!(/^~~~ #{tag} (.*)/) do |match|
    asset_name = "content/#{$1}"    
    raise "Could not find asset #{asset_name}" unless File.exists?(asset_name)
    puts "  #{tag} file: #{asset_name}"

    "```#{codetype}\n" + yield(asset_name) + "\n```"
  end
end

def sub_inline_docs!(content)
  sub_do('inline', content) do |asset_name|
    "[#{File.basename(asset_name)}]\n" + File.read(asset_name)
  end
end

def sub_inline_ruby!(content)
  sub_do('ruby', content, "ruby") do |asset_name|
    output = IO.popen("bundle exec xmpfilter -a --cd content/assets/ -I. #{asset_name}", "r").read
    raise "Error running inline ruby:\n#{output}" if output =~ /Error/
    output.gsub!(/^.*:startdoc:[^\n]*/m, '') if output =~ /:startdoc:/
    output.gsub!(/^.*:nodoc:.*$\n?/, '')
    output.gsub!(/\\n/,"\n# ")
    output.chomp!
    output
  end
end

def slurp_file(rawmd_file)
  content = File.read(rawmd_file)
  sub_inline_docs! content
  sub_inline_ruby! content
  content
end

task :default => :html

desc "Remove all generated files"
task :clean do
  FileUtils.rm_rf cookedmd_directory
  FileUtils.rm_rf html_directory
end

desc "Build cooked markdown version of the book"
task :markdown do
  STDOUT.sync = true
  FileUtils.mkdir_p cookedmd_directory
  output_filenames = []

  rawmd_file_list.each do |markdown_filename|
    output_filename = File.join(cookedmd_directory, File.basename(markdown_filename))
    output_filenames << output_filename
    if FileUtils.uptodate?(output_filename, Array(markdown_filename))
      puts "(#{output_filename} is up to date with #{markdown_filename})"
    else
      begin
        puts "writing to #{output_filename} from #{markdown_filename} ..."
        FileUtils.rm_f output_filename
        File.open(output_filename, "w") do |f|
          f.write slurp_file(markdown_filename)
        end
      rescue Exception => e
        FileUtils.rm output_filename
        raise e
      end
    end
  end

  all_tutorials = "#{cookedmd_directory}/all_tutorials.md"
  system "> #{all_tutorials}"
  output_filenames.each do |fn|
    system "cat #{fn} >> #{all_tutorials}"
  end
  puts "complete doc is #{all_tutorials}"
end

desc "Compile an html version of the book"
task :html => :markdown do
  STDOUT.sync = true
  FileUtils.mkdir_p html_directory
  output_filenames = []

  cookedmd_file_list.each do |markdown_filename|
    output_filename = format_html_filename(markdown_filename)
    output_filenames << output_filename
    if FileUtils.uptodate?(output_filename, Array(markdown_filename))
      puts "(#{output_filename} is up to date with #{markdown_filename})"
    else
      begin
        puts "writing to #{output_filename} from #{markdown_filename} ..."
        FileUtils.rm_f output_filename
        File.open(output_filename, "w") { |f| f.write "<meta charset='utf-8'>" }
        system "maruku -o #{output_filename} #{markdown_filename}"
      rescue Exception => e
        FileUtils.rm output_filename
        raise e
      end
    end
  end

  all_tutorials = "#{html_directory}/all_tutorials.html"
  system "> #{all_tutorials}"
  output_filenames.each do |fn|
    system "cat #{fn} >> #{all_tutorials}"
  end
  puts "complete doc is #{all_tutorials}"
end


desc "Describe the tutorials in YAML"
task :describe do
  require 'yaml'
  puts markdown_file_list.collect { |f| format_html_filename(f) }.to_yaml
end
