# coding: utf-8
def create_tutorial_tasks(source_dir, dest_dir)
  dest_paths = []

  each_glob_match_to_file_pairs("*.md", source_dir, dest_dir) do |source_path, dest_path|
    deps = source_file_dependencies(source_path) + [source_path]

    file dest_path => deps do
      FileUtils.mkdir_p File.dirname(dest_path)
      FileUtils.rm_f dest_path
      begin
        puts "writing to #{dest_path} from #{source_path}"
        File.open(dest_path, "w") do |f|
          f.write transmogrify_doc_file(source_path)
        end
      rescue Exception => e
        FileUtils.rm_f dest_path
        raise e
      end
    end

    dest_paths << dest_path
  end

  dest_paths << create_tutorial_toc_task(source_dir, dest_dir)

  each_glob_match_to_file_pairs("{CNAME,*.{png,svg,css}}", source_dir, dest_dir) do |source_path, dest_path|
    file dest_path => source_path do
      FileUtils.mkdir_p File.dirname(dest_path)
      FileUtils.cp source_path, dest_path, verbose: true
    end
    dest_paths << dest_path
  end

  dest_paths
end

def create_tutorial_toc_task(source_dir, dest_dir)
  mkdocs_yml_path = File.join(File.dirname(__FILE__), "../mkdocs.yml")
  toc_path = File.join(dest_dir, TUTORIALS_DIR, "toc.md")

  toc_md = ["# Nokogiri Tutorials\n"]

  nav = YAML.load_file(mkdocs_yml_path)["nav"]
  tutorials = nav.find { |x| x["Tutorials"] }.first.last
  tutorials.each do |tutorial|
    tutorial_title, tutorial_path = *(tutorial.flatten)
    next if tutorial_title =~ /Table of Contents/

    toc_md << "* [#{tutorial_title}](#{File.basename(tutorial_path)})"
  end

  file toc_path => mkdocs_yml_path do
    puts "generating tutorials' table of contents"
    File.open(toc_path, "w") do |f|
      f.write toc_md.join("\n")
    end
  end
end

def each_glob_match_to_file_pairs(glob, source_dir, dest_dir, &block)
  glob = "#{source_dir}/**/#{glob}"
  Dir[glob].each do |source_path|
    relative_path = File.join(source_path.split(File::SEPARATOR)[1..-1])
    dest_path = File.join(dest_dir, relative_path)
    block.call source_path, dest_path
  end
end

def source_file_dependencies(source_path)
  regex = /^~~~ \w+ (.*)/
  dirname = File.dirname(source_path)

  File.read(source_path).split("\n").grep(regex).inject([]) do |deps, line|
    deps += line.match(regex)[1].split
    deps
  end.collect { |dep| File.join(dirname, dep) }
end

def transmogrify_doc_file(rawmd_file)
  content = File.read rawmd_file
  Dir.chdir File.dirname(rawmd_file) do
    sub_inline_docs! content
    sub_inline_ruby! content
    content
  end
end

def sub_inline_docs!(content)
  sub_do("inline", content) do |asset_name|
    "[#{File.basename(asset_name)}]\n" + File.read(asset_name)
  end
end

def sub_inline_ruby!(content)
  sub_do("ruby", content) do |asset_name|
    asset_dir = File.dirname(asset_name)
    output = IO.popen("xmpfilter -a --cd #{asset_dir} -I. #{asset_name}", "r").read
    raise "Error running inline ruby:\n#{output}" if output =~ /Error/
    output.gsub!(/^.*:startdoc:[^\n]*/m, "") if output =~ /:startdoc:/
    output.gsub!(/^.*:nodoc:.*$\n?/, "")
    output.gsub!(/\\n/, "\n# ")
    output.chomp!
    output
  end
end

def sub_do(tag, content, &block)
  content.gsub!(/^~~~ #{tag} (.*)/) do |match|
    assets = $1.split
    output = []
    output << "``` #{codetype(assets.first)}\n" # assume all are the same type
    assets.each do |asset_name|
      raise "Could not find asset #{asset_name}" unless File.exists?(asset_name)
      puts "  #{tag} file: #{asset_name}"

      output << yield(asset_name)
    end
    output << "\n```"
    output.join
  end
end

def codetype(asset_name)
  case (asset_name.split(".").last)
  when "xml" then "xml"
  when "rb" then "ruby"
  else ""
  end
end
