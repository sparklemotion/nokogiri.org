require 'rubygems'
gem 'rcodetools'
gem 'maruku', '>= 0.6.0'

def markdown_file_list
  files = File.read("content/toc").split("\n")
  files.collect! {|file| file.downcase.downcase.gsub(/[\W ]/,"_") }
  files.collect! {|file| File.join("content", "#{file}.md")}
  files = files.select do |file|
    if File.exists? file
      true
    else
      STDERR.puts "WARNING: file #{file} does not exist!"
      false
    end
  end
end

def format_output_filename(markdown_filename)
  File.join("docs", File.basename(markdown_filename).gsub(/\.md$/, ".html"))
end

def run(cmd)
  puts "=> #{cmd}"
  system(cmd) || raise("command failed: #{cmd}")
end

def sub_do(tag, content, &block)
  content.gsub!(/^~~~ #{tag} (.*)/) do |match|
    asset_name = "content/#{$1}"    
    raise "Could not find asset #{asset_name}" unless File.exists?(asset_name)
    puts "  #{tag} file: #{asset_name}"

    yield(asset_name).gsub!(/^/,'    ')
  end
end

def sub_inline_docs!(content)
  sub_do('inline', content) do |asset_name|
    "[#{File.basename(asset_name)}]\n" + File.read(asset_name)
  end
end

def sub_inline_ruby!(content)
  sub_do('ruby', content) do |asset_name|
    output = IO.popen("xmpfilter -a --cd content/assets/ #{asset_name}", "r").read
    output.gsub!(/^.*:startdoc:[^\n]*/m, '') if output =~ /:startdoc:/
    output.gsub!(/^.*:nodoc:.*$\n?/, '')
    output.gsub!(/\\n/,"\n# ")
    output.chomp!
  end
end

def slurp_file(markdown_file)
  content = File.read(markdown_file)
  sub_inline_docs! content
  sub_inline_ruby! content
  content
end

task :default => :html

desc "Compile an html version of the book"
task :html do
  STDOUT.sync = true
  FileUtils.mkdir_p "docs"
  output_filenames = []

  markdown_file_list.each do |markdown_filename|
    output_filename = format_output_filename(markdown_filename)
    output_filenames << output_filename
    if FileUtils.uptodate?(output_filename, markdown_filename)
      puts "(#{output_filename} is up to date with #{markdown_filename})"
    else
      puts "writing to #{output_filename} from #{markdown_filename} ..."
      IO.popen("maruku > #{output_filename}", "w") do |f|
        f.write slurp_file(markdown_filename)
      end
    end
  end

  system "> docs/cookbook.html"
  output_filenames.each do |fn|
    system "cat #{fn} >> docs/cookbook.html"
  end
  puts "complete doc is docs/cookbook.html"
end


desc "Describe the cookbook in YAML"
task :describe do
  puts markdown_file_list.collect { |f| format_output_filename(f) }.to_yaml
end
