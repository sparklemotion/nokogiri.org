# coding: utf-8
describe "nokogiri.org" do
  feature "legacy URLs" do
    it "should support legacy help link" do
      visit "/tutorials/getting_help.html"
      expect(page.status_code).to eq(200)
    end

    it "should support legacy installation link" do
      visit "/tutorials/installing_nokogiri.html"
      expect(page.status_code).to eq(200)
    end

    it "should support legacy security link" do
      visit "/tutorials/security.html"
      expect(page.status_code).to eq(200)
    end
  end

  feature "navigation" do
    let(:within_css) { "body" }

    around do |example|
      visit "/"
      within within_css do
        example.run
      end
    end

    feature "nav" do
      it { expect(page).to have_link("Docs", href: "https://rdoc.info/github/sparklemotion/nokogiri") }
      it { expect(page).to have_link("Build Status", href: "https://ci.nokogiri.org/") }
    end

    feature "footer" do
      let(:within_css) { NokogiriTestConfig::CSS::Footer }

      it "points at the tutorials repo" do
        expect(page).to have_link("sparklemotion/nokogiri.org", href: "https://github.com/sparklemotion/nokogiri.org")
      end
    end
  end
end
