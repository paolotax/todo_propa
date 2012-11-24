require 'spec_helper'

describe "appunto_events/show" do
  before(:each) do
    @appunto_event = assign(:appunto_event, stub_model(AppuntoEvent,
      :appunto => "",
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/State/)
  end
end
