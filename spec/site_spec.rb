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
end
