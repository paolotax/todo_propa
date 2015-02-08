require 'spec_helper'

describe "documenti/show" do
  before(:each) do
    @documento = assign(:documento, stub_model(Documento))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
