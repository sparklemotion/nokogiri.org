require 'yaml'

namespace :tutorials do
  tut_dest     = File.expand_path "source/tutorials"
  tut_repo     = File.expand_path "tutorials"
  tut_web_path = "tutorials"
  asset_dest = File.expand_path "source/assets"
  asset_src  = File.expand_path "tutorials/assets"

  desc "Sync the tutorials content into the site content."
  task :generate do
    def write_front_matter io, front_matter
      front_matter["layout"] ||= "page"
      front_matter["sidebar"] = false unless front_matter.has_key?("sidebar")

      io.write front_matter.to_yaml
      io.puts "---"
    end

    files = Bundler.with_clean_env do
      Dir.chdir "tutorials" do
        system "bundle install"
        system "bundle exec rake markdown"
        YAML.load(`bundle exec rake describe`)
      end
    end

    chapters = [].tap do |chapters|
      files.each do |title, filename|
        chapters << {
          "title" =>       title,
          "filename" =>    filename,
          "source_file" => File.join(tut_repo, filename),
          "dest_file" =>   File.join(tut_dest, File.basename(filename)),
          "web_file" =>    File.join("/", tut_web_path, File.basename(filename).gsub(/\.md$/, ".html")),
        }
      end
    end
    chapters.each_with_index do |chapter, j|
      if j >= 1
        chapter["prev"] ||= {}
        chapter["prev"]["title"] = chapters[j-1]["title"]
        chapter["prev"]["url"] = chapters[j-1]["web_file"]
      end
      if j < chapters.length-1
        chapter["next"] ||= {}
        chapter["next"]["title"] = chapters[j+1]["title"]
        chapter["next"]["url"] = chapters[j+1]["web_file"]
      end
    end

    FileUtils.rm_rf tut_dest
    FileUtils.mkdir_p tut_dest
    File.open "source/tutorials/index.md", "w" do |index|
      write_front_matter index, {
        "title" => "Tutorials"
      }

      chapters.each do |chapter|
        File.open chapter["dest_file"], "w" do |file|
          front_matter = {
            "title" => chapter["title"]
          }
          front_matter["prev"] = chapter["prev"] if chapter["prev"]
          front_matter["next"] = chapter["next"] if chapter["next"]

          write_front_matter file, front_matter
          file.write File.read(chapter["source_file"])
        end
        index.puts "1. [#{chapter["title"]}](#{chapter["web_file"]})"
      end
    end

    FileUtils.rm_rf asset_dest,            :verbose => true
    FileUtils.cp_r  asset_src, asset_dest, :verbose => true
  end

  desc "recursively clean the tutorials submodule"
  task :clean do
    Bundler.with_clean_env do
      Dir.chdir "tutorials" do
        system "rake clean"
      end
    end
    FileUtils.rm_rf tut_dest, :verbose => true
  end
end
