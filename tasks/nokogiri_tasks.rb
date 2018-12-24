def create_nokogiri_tasks source_dir, dest_dir
  FileUtils.mkdir_p dest_dir

  file_pairs = {
    "LICENSE.md" => "LICENSE.md",
    "SECURITY.md" => "SECURITY.md",
    "tutorials/security.md" => "SECURITY.md",
    "CHANGELOG.md" => "CHANGELOG.md",
    "index.md" => "README.md",
  }

  dest_paths = []

  file_pairs.each do |dest_file, source_file|
    source_path = File.join(nokogiri_dir, source_file)
    dest_path = File.join(dest_dir, dest_file)
    dest_paths << dest_path

    if ! File.exist?(source_path)
      raise "Could not find file #{source_path}, please set \$NOKOGIRI_DIR if necessary"
    end

    file dest_path => source_path do
      FileUtils.cp source_path, dest_path, verbose: true
    end
  end
  dest_paths
end

def nokogiri_dir
  ENV["NOKOGIRI_DIR"] || "../nokogiri"
end
