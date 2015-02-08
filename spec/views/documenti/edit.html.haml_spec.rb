require 'spec_helper'

describe "documenti/edit" do
  before(:each) do
    @documento = assign(:documento, stub_model(Documento))
  end

  it "renders the edit documento form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => documenti_path(@documento), :method => "post" do
    end
  end
end
