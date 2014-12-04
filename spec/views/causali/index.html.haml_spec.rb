require 'spec_helper'

describe "causali/index" do
  before(:each) do
    assign(:causali, [
      stub_model(Causale,
        :causale => "Causale",
        :magazzino => "Magazzino",
        :movimento => "Movimento"
      ),
      stub_model(Causale,
        :causale => "Causale",
        :magazzino => "Magazzino",
        :movimento => "Movimento"
      )
    ])
  end

  it "renders a list of causali" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Causale".to_s, :count => 2
    assert_select "tr>td", :text => "Magazzino".to_s, :count => 2
    assert_select "tr>td", :text => "Movimento".to_s, :count => 2
  end
end
