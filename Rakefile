require "rspec/core/rake_task"
require "yaml"
require "launchy"

STAGING_DIR = "staging"
SITE_DIR = "site"
TUTORIALS_DIR = "tutorials"
TUTORIALS_MARKDOWN_DIR = File.join(TUTORIALS_DIR, "markdown")

namespace :dev do
  desc "Set up system dependencies to develop this site."
  task :setup do
    system "pip install --user mkdocs pygments"
    
    Bundler.with_clean_env do
      Dir.chdir TUTORIALS_DIR do
        system "bundle install"
      end
    end
  end
end

namespace :tutorials do
  desc "Pull in tutorial content"
  task :generate do
    FileUtils.mkdir_p STAGING_DIR

    Bundler.with_clean_env do
      Dir.chdir TUTORIALS_DIR do
        system "bundle exec rake markdown"
      end
    end

    system "cp -varL #{TUTORIALS_MARKDOWN_DIR}/* #{STAGING_DIR}"
  end

  desc "recursively clean the tutorials submodule"
  task :clean do
    Bundler.with_clean_env do
      Dir.chdir TUTORIALS_DIR do
        system "rake clean"
      end
    end
  end
end

namespace :nokogiri do
  def nokogiri_dir
    ENV["NOKOGIRI_DIR"] || "../nokogiri"
  end

  desc "Pull in Nokogiri repo files"
  task :generate do
    FileUtils.mkdir_p STAGING_DIR
    {
      "LICENSE.md" => "LICENSE.md",
      "SECURITY.md" => "security.md",
      "README.md" => "index.md",
    }.each do |source_file, dest_file|
      source_path = File.join(nokogiri_dir, source_file)
      if ! File.exist?(source_path)
        raise "Could not find file #{source_path}, please set \$NOKOGIRI_DIR if necessary"
      end
      dest_path = File.join(STAGING_DIR, dest_file)
      FileUtils.cp source_path, dest_path, verbose: true
    end
  end
end

namespace :mkdocs do
  MKDOCS_CONFIG = "mkdocs.yml"

  def mkdocs_inject_toc
    toc = Bundler.with_clean_env do
      Dir.chdir TUTORIALS_DIR do
        YAML.load(`bundle exec rake describe`)
      end
    end
    nav = toc.inject([]) do |nav, (title, filename)|
      nav << { title => File.basename(filename) }
      nav
    end
    mkdocs_config = YAML.load_file(MKDOCS_CONFIG)
    mkdocs_config["nav"] = nav
    File.open(MKDOCS_CONFIG, "w") { |f| f.write mkdocs_config.to_yaml }
  end

  desc "Use mkdocs to generate a static site"
  task :generate do
    system "mkdocs build"
    mkdocs_inject_toc
  end

  desc "Use mkdocs to generate a static site"
  task :preview do
    Thread.new do
      sleep 1
      Launchy.open "http://localhost:8000"
    end
    system "mkdocs serve"
  end
end

task :clean do
  FileUtils.rm_rf STAGING_DIR
  FileUtils.rm_rf SITE_DIR
end

desc "generate a static site"
task :generate => ["clean", "tutorials:generate", "nokogiri:generate", "mkdocs:generate"]

desc "preview the site"
task :preview => ["tutorials:generate", "nokogiri:generate", "mkdocs:preview"]



RSpec::Core::RakeTask.new(:spec)

task :spec => :generate

task :default => :spec
