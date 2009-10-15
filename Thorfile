class Book < Thor
  desc "html", "Compile an html version of the book"
  def html
    files = File.read("content/toc").split
    files.collect! {|file| File.join("content", file)}
    cmd = "cat #{files.join(' ')} | maruku > nokogiri-cookbook.html"
    puts cmd
    system cmd
  end
end
