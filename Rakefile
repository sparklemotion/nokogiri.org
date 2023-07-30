require "rspec/core/rake_task"
require "yaml"
require "launchy"

STAGING_DIR = "staging"
SITE_DIR = "site"
TUTORIALS_DIR = "tutorials"

require_relative "tasks/tutorial_tasks"
require_relative "tasks/nokogiri_tasks"

namespace :dev do
  MKDOCS_DIR = "../mkdocs"
  MKDOCS_MATERIAL_INSIDERS_DIR = "mkdocs-material"

  desc "Set up system dependencies to develop this site."
  task :setup do
    sh "pip3 install --upgrade --user pygments pymdown-extensions pillow cairosvg"
    sh "pip3 uninstall --yes mkdocs-material"

    if File.directory?(MKDOCS_MATERIAL_INSIDERS_DIR)
      Dir.chdir(MKDOCS_MATERIAL_INSIDERS_DIR) do
        # https://squidfunk.github.io/mkdocs-material/customization/#environment-setup
        sh "pip3 install --user -e ."
        sh "pip install mkdocs-minify-plugin"
        sh "pip install mkdocs-redirects"
        sh "npm install"
      end
    else
      puts "WARNING: you don't have mkdocs-material-insiders installed, using OSS version"
      sh "pip3 install --upgrade --user mkdocs-material"
    end
  end

  # there is a patch of mkdocs-material search plugin to support rdoc pages here:
  #  https://gist.github.com/flavorjones/a2ee50d94888537d561db53c837c4bbf

  task :build do |_, args|
    dirty_p = args.extras.include?("dirty")
    Dir.chdir(MKDOCS_MATERIAL_INSIDERS_DIR) do
      if dirty_p
        sh "npm run build:dirty"
      else
        sh "npm run build"
      end
    end
  end
end

desc "Push everything to Github Pages"
task :deploy => :generate do
  sh "mkdocs gh-deploy"
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

namespace :mkdocs do
  desc "Use mkdocs to generate a static site"
  task :generate do
    sh "mkdocs build"
  end

  desc "Use mkdocs to generate a static site"
  task :preview do
    Thread.new do
      sleep 1
      Launchy.open "http://localhost:8000"
    end
    sh "mkdocs serve"
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
