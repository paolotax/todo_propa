require 'spec_helper'

describe "documenti/index" do
  before(:each) do
    assign(:documenti, [
      stub_model(Documento),
      stub_model(Documento)
    ])
  end

  it "renders a list of documenti" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
