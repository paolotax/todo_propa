require 'spec_helper'

describe "appunto_events/edit" do
  before(:each) do
    @appunto_event = assign(:appunto_event, stub_model(AppuntoEvent,
      :appunto => "",
      :state => "MyString"
    ))
  end

  it "renders the edit appunto_event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => appunto_events_path(@appunto_event), :method => "post" do
      assert_select "input#appunto_event_appunto", :name => "appunto_event[appunto]"
      assert_select "input#appunto_event_state", :name => "appunto_event[state]"
    end
  end
end
