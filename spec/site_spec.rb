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

  feature "permalinks" do
    it "should support a Tutorials TOC landing page" do
      visit "/tutorials/toc.html"
      expect(page.status_code).to eq(200)
    end
  end

  feature "tidelift URLs" do
    let(:tidelift_url) { "https://tidelift.com/subscription/pkg/rubygems-nokogiri?utm_source=rubygems-nokogiri&utm_medium=referral&utm_campaign=website" }
    let(:tidelift_enterprise_url) { "https://tidelift.com/subscription/pkg/rubygems-nokogiri?utm_source=rubygems-nokogiri&utm_medium=referral&utm_campaign=enterprise" }
    let(:tidelift_enterprise_demo_url) { "https://tidelift.com/subscription/request-a-demo?utm_source=rubygems-nokogiri&utm_medium=referral&utm_campaign=enterprise" }

    it "should link to tidelift from home page" do
      visit "/"
      expect(page).to have_link("Get support for Nokogiri with a Tidelift subscription", href: tidelift_url)
    end

    it "should have a 'for enterprise' page in nav" do
      visit "/"
      within("nav.md-tabs") do
        click_link("Support")
      end
      within("nav.md-nav[data-md-level=0]") do
        expect(page).to have_link("Nokogiri for Enterprise", href: "../tidelift-landing.html")
      end
    end

    it "should have a 'for enterprise' page" do
      visit "/tidelift-landing.html"
      expect(page).to have_content("Available as part of the Tidelift Subscription")
      expect(page).to have_link("Learn More", href: tidelift_enterprise_url)
      expect(page).to have_link("Request a Demo", href: tidelift_enterprise_demo_url)
    end
  end
end
