require 'spec_helper'

describe "documenti/new" do
  before(:each) do
    assign(:documento, stub_model(Documento).as_new_record)
  end

  it "renders new documento form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => documenti_path, :method => "post" do
    end
  end
end
