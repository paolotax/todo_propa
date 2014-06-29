require 'spec_helper'

describe "editori/index" do
  before(:each) do
    assign(:editori, [
      stub_model(Editore,
        :nome => "Nome",
        :gruppo => "Gruppo",
        :codice => "Codice"
      ),
      stub_model(Editore,
        :nome => "Nome",
        :gruppo => "Gruppo",
        :codice => "Codice"
      )
    ])
  end

  it "renders a list of editori" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nome".to_s, :count => 2
    assert_select "tr>td", :text => "Gruppo".to_s, :count => 2
    assert_select "tr>td", :text => "Codice".to_s, :count => 2
  end
end
