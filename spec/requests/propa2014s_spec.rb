require 'spec_helper'

describe "Propa2014s" do
  describe "GET /propa2014s" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get propa2014s_path
      response.status.should be(200)
    end
  end
end
