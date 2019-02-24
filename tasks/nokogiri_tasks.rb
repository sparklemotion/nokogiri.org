# coding: utf-8
RDOC_STAGING_DIR = File.join(STAGING_DIR, "rdoc")

def create_nokogiri_tasks(source_dir, dest_dir)
  FileUtils.mkdir_p dest_dir

  file_pairs = {
    "LICENSE.md" => "LICENSE.md",
    "LICENSE-DEPENDENCIES.md" => "LICENSE-DEPENDENCIES.md",
    "SECURITY.md" => "SECURITY.md",
    "CODE_OF_CONDUCT.md" => "CODE_OF_CONDUCT.md",
    "tutorials/security.md" => "SECURITY.md",
    "CHANGELOG.md" => "CHANGELOG.md",
    "index.md" => "README.md",
  }

  dest_paths = []

  file_pairs.each do |dest_file, source_file|
    source_path = File.join(nokogiri_dir, source_file)
    dest_path = File.join(dest_dir, dest_file)
    dest_paths << dest_path

    if !File.exist?(source_path)
      raise "Could not find file #{source_path}, please set \$NOKOGIRI_DIR if necessary"
    end

    file dest_path => source_path do
      FileUtils.cp source_path, dest_path, verbose: true
    end
  end

  desc "Generate and pull in Nokogiri rdocs"
  task :rdoc do
    nokogiri_generate_rdocs
    nokogiri_add_ga_to_rdocs
  end
  dest_paths << "nokogiri:rdoc"

  dest_paths
end

require "nokogiri"

def nokogiri_dir
  ENV["NOKOGIRI_DIR"] || "../nokogiri"
end

def nokogiri_generate_rdocs
  return if File.exist?(File.join(RDOC_STAGING_DIR, "index.html"))

  pwd = Dir.pwd
  Dir.chdir(nokogiri_dir) do
    system "yard doc --output-dir #{File.join(pwd, RDOC_STAGING_DIR)}"
  end
end

def nokogiri_add_ga_to_rdocs
  # idea borrowed from
  # https://blog.arangamani.net/blog/2013/08/04/apply-google-analytics-tracking-to-yard-documentation/
  files = Dir[File.join(RDOC_STAGING_DIR, "/**/*.html")]

  snippet_tag = "Global site tag (gtag.js) - Google Analytics"
  snippet = <<-EOJS
    <!-- #{snippet_tag} -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-1260604-8"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'UA-1260604-8');
    </script>
  EOJS

  files.each do |file_path|
    html = File.read(file_path)
    next if html.include?(snippet_tag)

    puts "→ adding google analytics snippet to #{file_path}"
    doc = Nokogiri::HTML.parse(html)
    doc.at_css("head").add_child(snippet)
    File.open(file_path, "w") { |f| f.write doc.to_html }
  end
end
