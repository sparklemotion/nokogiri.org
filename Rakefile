require "rspec/core/rake_task"
require "yaml"
require "launchy"

STAGING_DIR = "staging"
SITE_DIR = "site"
TUTORIALS_DIR = "tutorials"

require_relative "tasks/tutorial_tasks"
require_relative "tasks/nokogiri_tasks"

namespace :dev do
  desc "Set up system dependencies to develop this site."
  task :setup do
    sh "uv sync"
  end
end

desc "Push everything to Github Pages"
task :deploy => :generate do
  sh "uv run ghp-import --push --no-jekyll #{SITE_DIR}"
end

namespace :tutorials do
  tasks = create_tutorial_tasks("docs", STAGING_DIR)

  desc "Pull in tutorial content"
  task :generate => tasks
end

namespace :nokogiri do
  tasks = create_nokogiri_tasks(nokogiri_dir, STAGING_DIR)

  desc "Pull in Nokogiri repo files"
  task :generate => tasks
end

namespace :zensical do
  desc "Use zensical to generate a static site"
  task :generate do
    sh "uv run zensical build"
    sh "uv run python scripts/index_rdoc.py"
  end

  desc "Use zensical to preview with live reload"
  task :preview do
    search_json = File.expand_path(File.join(SITE_DIR, "search.json"))
    initial_mtime = File.exist?(search_json) ? File.mtime(search_json) : nil

    queue = Queue.new

    # Watcher thread - detects when search.json is created/updated
    watcher = Thread.new do
      loop do
        if File.exist?(search_json)
          current_mtime = File.mtime(search_json)
          if current_mtime != initial_mtime
            queue.push(:ready)
            break
          end
        end
        sleep 0.1
      end
    end

    # Consumer thread - waits for signal, then indexes and opens browser
    consumer = Thread.new do
      queue.pop  # blocks until watcher pushes
      system "uv run python scripts/index_rdoc.py"
      Launchy.open "http://localhost:8000"
    end

    sh "uv run zensical serve"
  end
end

task :clean do
  FileUtils.rm_rf STAGING_DIR
  FileUtils.rm_rf SITE_DIR
end

desc "generate a static site"
task :generate => ["tutorials:generate", "nokogiri:generate", "zensical:generate"]

desc "preview the site"
task :preview => ["tutorials:generate", "nokogiri:generate", "zensical:preview"]

RSpec::Core::RakeTask.new(:spec)
task :spec => :generate
task :default => :spec
