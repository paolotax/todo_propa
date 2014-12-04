require 'spec_helper'

describe "causali/show" do
  before(:each) do
    @causale = assign(:causale, stub_model(Causale,
      :causale => "Causale",
      :magazzino => "Magazzino",
      :movimento => "Movimento"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Causale/)
    rendered.should match(/Magazzino/)
    rendered.should match(/Movimento/)
  end
end
