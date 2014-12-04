require 'spec_helper'

describe "causali/new" do
  before(:each) do
    assign(:causale, stub_model(Causale,
      :causale => "MyString",
      :magazzino => "MyString",
      :movimento => "MyString"
    ).as_new_record)
  end

  it "renders new causale form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => causali_path, :method => "post" do
      assert_select "input#causale_causale", :name => "causale[causale]"
      assert_select "input#causale_magazzino", :name => "causale[magazzino]"
      assert_select "input#causale_movimento", :name => "causale[movimento]"
    end
  end
end
