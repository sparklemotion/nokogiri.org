require 'rubygems'
gem 'rcodetools'

RAWMD_DIRECTORY = "content"
RAWASSETS_DIRECTORY = "assets"
COOKEDMD_DIRECTORY = "markdown"
COOKEDASSETS_DIRECTORY = File.join(COOKEDMD_DIRECTORY, RAWASSETS_DIRECTORY)

#
#  utility functions. yes, this is a hot mess.
#
def book_toc_titles
  File.read(File.join(RAWMD_DIRECTORY, "toc")).split("\n")
end

def rawmd_file_list
  book_toc_titles.
    collect {|file| file.downcase.downcase.gsub(/[\W ]/,"_") }.
    collect {|file| File.join(RAWMD_DIRECTORY, "#{file}.md")}.
    tap do |files|
      files.each {|file| raise "#{file} does not exist" unless File.exists?(file) }
    end
end

def cookedmd_file_list
  rawmd_file_list.collect {|file| File.join(COOKEDMD_DIRECTORY, File.basename(file)) }
end

def file_hash
  rawmd_file_list.zip(cookedmd_file_list).to_h
end

def run(cmd)
  puts "=> #{cmd}"
  system(cmd) || raise("command failed: #{cmd}")
end

def codetype asset_name
  case (asset_name.split(".").last)
  when "xml" then "xml"
  when "rb" then "ruby"
  else ""
  end
end

def rawmd_dependencies content
  regex = /^~~~ \w+ (.*)/
  deps = []
  content.split("\n").grep(regex).each do |line|
    deps += line.match(regex)[1].split
  end
  deps.collect { |dep| File.join(RAWMD_DIRECTORY, dep) }
end

def sub_do(tag, content, &block)
  content.gsub!(/^~~~ #{tag} (.*)/) do |match|
    assets = $1.split
    output = []
    output << "``` #{codetype(assets.first)}\n" # assume all are the same type
    assets.each do |asset|
      asset_name = File.join("content", asset)
      raise "Could not find asset #{asset_name}" unless File.exists?(asset_name)
      puts "  #{tag} file: #{asset_name}"

      output << yield(asset_name)
    end
    output << "\n```"
    output.join
  end
end

def sub_inline_docs!(content)
  sub_do('inline', content) do |asset_name|
    "[#{File.basename(asset_name)}]\n" + File.read(asset_name)
  end
end

def sub_inline_ruby!(content)
  sub_do('ruby', content) do |asset_name|
    output = IO.popen("bundle exec xmpfilter -a --cd content/assets/ -I. #{asset_name}", "r").read
    raise "Error running inline ruby:\n#{output}" if output =~ /Error/
    output.gsub!(/^.*:startdoc:[^\n]*/m, '') if output =~ /:startdoc:/
    output.gsub!(/^.*:nodoc:.*$\n?/, '')
    output.gsub!(/\\n/,"\n# ")
    output.chomp!
    output
  end
end

def chapter_toc(content)
  header_re = /^(##) /
  markdown_link_re = /\[(.*)\](\[.*\]|\(.*\))/
  toc = []
  content = content.split("\n").map do |line|
    if line =~ header_re
      title = line.gsub(header_re, '')
      header = $1

      if title =~ markdown_link_re
        title = title.gsub(markdown_link_re, '\1')
      end

      # extract id and store it into toc
      id = title.downcase.gsub(/\W/, '_')
      toc_entry = "1. [#{title}](##{id})"
      toc << toc_entry

      # then edit header markup to have that id
      line = "#{header} <span id='#{id}'> #{title} </span>"
    else
      line
    end
  end

  toc << ""
  toc << "<hr class='divider'>"
  toc << ""

  (toc + content).join("\n")
end

def slurp_file(rawmd_file)
  content = File.read(rawmd_file)
  sub_inline_docs! content
  sub_inline_ruby! content
  content = chapter_toc(content)
  content
end


#
#  rake tasks
#
file_hash.each do |rawmd_filename, cookedmd_filename|
  deps = rawmd_dependencies(File.read(rawmd_filename))
  deps << rawmd_filename
  deps.each { |dep| file dep }

  file cookedmd_filename => deps do
    FileUtils.mkdir_p COOKEDMD_DIRECTORY
    begin
      puts "writing to #{cookedmd_filename} from #{rawmd_filename} ..."
      FileUtils.rm_f cookedmd_filename
      File.open(cookedmd_filename, "w") do |f|
        f.write slurp_file(rawmd_filename)
      end
    rescue Exception => e
      FileUtils.rm_rf cookedmd_filename
      raise e
    end
  end
end

file COOKEDASSETS_DIRECTORY do
  FileUtils.ln_sf File.join("..", RAWASSETS_DIRECTORY), COOKEDASSETS_DIRECTORY
end

desc "Remove all generated files"
task :clean do
  FileUtils.rm_rf COOKEDMD_DIRECTORY, :verbose => true
end

desc "Build cooked markdown version of the book"
task :markdown => [cookedmd_file_list, COOKEDASSETS_DIRECTORY].flatten

desc "Describe the markdown tutorials in YAML"
task :describe do
  require 'yaml'
  puts book_toc_titles.zip(cookedmd_file_list).to_h.to_yaml
end

task :default => :markdown

desc "import any files you need from the nokogiri repo"
task :import do
  system 'curl https://raw.githubusercontent.com/sparklemotion/nokogiri/master/SECURITY.md -o content/security.md'
end
