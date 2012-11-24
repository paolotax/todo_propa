require 'spec_helper'

describe "appunto_events/index" do
  before(:each) do
    assign(:appunto_events, [
      stub_model(AppuntoEvent,
        :appunto => "",
        :state => "State"
      ),
      stub_model(AppuntoEvent,
        :appunto => "",
        :state => "State"
      )
    ])
  end

  it "renders a list of appunto_events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
