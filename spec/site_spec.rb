# coding: utf-8
describe "nokogiri.org" do
  let(:within_css) { "body" }

  around do |example|
    visit "/"
    within within_css do
      example.run
    end
  end

  feature "navbar" do
    let(:within_css) { NokogiriTestConfig::CSS::Nav }

    it { expect(page).to have_link("GitHub", href: "https://github.com/sparklemotion/nokogiri") }
    it { expect(page).to have_link("Docs", href: "https://rdoc.info/github/sparklemotion/nokogiri") }
    it { expect(page).to have_link("Build Status", href: "https://ci.nokogiri.org/") }
    it { expect(page).to have_link("Install Help", href: "/tutorials/installing_nokogiri.html") }
    it { expect(page).to have_link("Tutorials", href: "/tutorials/") }
    it { expect(page).to have_link("Support", href: "/tutorials/getting_help.html") }
    it { expect(page).to have_link("Security", href: "/tutorials/security.html") }
  end

  feature "header" do
    let(:within_css) { NokogiriTestConfig::CSS::Header }

    it "has the logo" do
      expect(page).to have_content("Nokogiri 鋸")
    end
  end

  feature "footer" do
    let(:within_css) { NokogiriTestConfig::CSS::Footer }

    it "points at the tutorials repo" do
      expect(page).to have_link("sparklemotion/nokogiri.org-tutorials", href: "https://github.com/sparklemotion/nokogiri.org-tutorials")
    end
  end

  feature "table of contents" do
    let(:chapters) do
      Bundler.with_clean_env do
        Dir.chdir NokogiriTestConfig::PATH::Tutorials do
          YAML.load(`bundle exec rake describe`)
        end
      end
    end

    it "has entries for each markdown file" do
      chapters.each do |title, path|
        filename = File.basename(path).gsub(".md", ".html")
        expect(page).to have_link(title, href: "/tutorials/#{filename}")
      end
    end
  end
end
