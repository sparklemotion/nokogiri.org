# coding: utf-8
# frozen_string_literal: true
require 'cgi'

RDOC_STAGING_DIR = File.join(STAGING_DIR, "rdoc")

def create_nokogiri_tasks(source_dir, dest_dir)
  FileUtils.mkdir_p(dest_dir)

  file_pairs = {
    "LICENSE.md" => "LICENSE.md",
    "LICENSE-DEPENDENCIES.md" => "LICENSE-DEPENDENCIES.md",
    "SECURITY.md" => "SECURITY.md",
    "CODE_OF_CONDUCT.md" => "CODE_OF_CONDUCT.md",
    "tutorials/security.md" => "SECURITY.md",
    "CHANGELOG.md" => "CHANGELOG.md",
    "misc/CHANGELOG-archive.md" => "misc/CHANGELOG-archive.md",
    "CONTRIBUTING.md" => "CONTRIBUTING.md",
    "ROADMAP.md" => "ROADMAP.md",
    "index.md" => "README.md",
  }

  linkify_files = ["CHANGELOG.md"]

  Dir.chdir(nokogiri_dir) do
    Dir.glob(File.join("adr", "*.md")).each do |adr|
      file_pairs[adr] = adr
    end
  end

  dest_paths = []

  file_pairs.each do |dest_file, source_file|
    source_path = File.join(nokogiri_dir, source_file)
    dest_path = File.join(dest_dir, dest_file)
    dest_paths << dest_path

    unless File.exist?(source_path)
      raise "Could not find file #{source_path}, please set \$NOKOGIRI_DIR if necessary"
    end

    file(dest_path => source_path) do
      target_dir = File.dirname(dest_path)
      FileUtils.mkdir_p(target_dir, verbose: true) unless File.directory?(target_dir)
      FileUtils.cp(source_path, dest_path, verbose: true)
      modify_readme_links(dest_path)
      github_linkify(dest_path) if linkify_files.include?(dest_file)
    end
  end

  desc("Generate and pull in Nokogiri rdocs")
  task(:rdoc) do
    nokogiri_generate_rdocs
    nokogiri_add_ga_to_rdocs
    nokogiri_add_header_ids_to_rdocs
  end
  dest_paths << "nokogiri:rdoc"

  desc("Clean the Nokogiri rdocs")
  task(:rdoc_clean) do
    nokogiri_clean_rdocs
  end

  dest_paths
end

def github_linkify(path)
  require "hoe/markdown"
  md = File.read(path)
  md = Hoe::Markdown::Util.linkify_github_usernames(md)
  md = Hoe::Markdown::Util.linkify_github_issues(md, "https://github.com/sparklemotion/nokogiri/issues")
  File.write(path, md)
end

require "nokogiri"

def nokogiri_dir
  ENV["NOKOGIRI_DIR"] || "../nokogiri"
end

def nokogiri_generate_rdocs
  return if File.exist?(File.join(RDOC_STAGING_DIR, "index.html"))

  pwd = Dir.pwd
  Dir.chdir(nokogiri_dir) do
    Bundler.with_unbundled_env do
      sh("RDOC_DIR=#{File.join(pwd, RDOC_STAGING_DIR)} bundle exec rake rdoc")
    end
  end
end

def nokogiri_clean_rdocs
  FileUtils.rm_rf(RDOC_STAGING_DIR, verbose: true)
end

def nokogiri_add_ga_to_rdocs
  # idea borrowed from
  # https://blog.arangamani.net/blog/2013/08/04/apply-google-analytics-tracking-to-yard-documentation/
  files = Dir[File.join(RDOC_STAGING_DIR, "/**/*.html")]

  snippet_tag = "Global site tag (gtag.js) - Google Analytics"
  snippet = <<~EOJS
    <!-- #{snippet_tag} -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-BZR5RZN084"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-BZR5RZN084');
    </script>
  EOJS

  puts "→ adding google analytics snippet to #{files.length} rdoc files"
  files.each do |file_path|
    html = File.read(file_path)
    next if html.include?(snippet_tag)

    doc = Nokogiri::HTML.parse(html)

    doc.at_css("head").add_child(snippet)

    File.open(file_path, "w") { |f| f.write(doc.to_html) }
  end
end

#  for mkdocs indexing to work properly, headers need ids (for section urls)
#  note that yardoc adds ids to h3, but we need to do this for h1 and h2
def nokogiri_add_header_ids_to_rdocs
  files = Dir[File.join(RDOC_STAGING_DIR, "/**/*.html")]

  puts "→ adding header ids to #{files.length} rdoc files"
  files.each do |file_path|
    html = File.read(file_path)

    doc = Nokogiri::HTML.parse(html)

    doc.css("h1", "h2").each do |header|
      next if header["id"]
      id = case header.name
           when "h1"
             header.content.strip
           when "h2"
             header.children.find { |c| c.text? && c.content.strip.length > 0 }&.content&.strip
           end
      header["id"] = CGI.escape(id) if id
    end

    File.open(file_path, "w") { |f| f.write(doc.to_html) }
  end
end

def modify_readme_links(dest_path)
  contents = File.read(dest_path)
  modified_contents = contents.gsub(/\]\(README.md\)/, "](index.md)")
  if contents != modified_contents
    puts "→ repointing a README.md link in #{dest_path}"
    File.open(dest_path, "w") { |f| f.write(modified_contents) }
  end
end
