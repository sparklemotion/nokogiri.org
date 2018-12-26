require "rspec/core/rake_task"
require "yaml"
require "launchy"

require_relative "tasks/tutorial_tasks"
require_relative "tasks/nokogiri_tasks"

STAGING_DIR = "staging"
SITE_DIR = "site"
TUTORIALS_DIR = "tutorials"

namespace :dev do
  desc "Set up system dependencies to develop this site."
  task :setup do
    system "pip install --user mkdocs pygments mkdocs-material pymdown-extensions"
  end
end

namespace :tutorials do
  desc "Pull in tutorial content"
  task :generate => create_tutorial_tasks("docs", "staging")

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
  desc "Pull in Nokogiri repo files"
  task :generate => create_nokogiri_tasks(nokogiri_dir, STAGING_DIR)
end

namespace :mkdocs do
  desc "Use mkdocs to generate a static site"
  task :generate do
    system "mkdocs build"
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
task :generate => ["tutorials:generate", "nokogiri:generate", "mkdocs:generate"]

desc "preview the site"
task :preview => ["tutorials:generate", "nokogiri:generate", "mkdocs:preview"]

RSpec::Core::RakeTask.new(:spec)
task :spec => :generate
task :default => :spec
