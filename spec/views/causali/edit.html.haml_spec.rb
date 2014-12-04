require 'spec_helper'

describe "causali/edit" do
  before(:each) do
    @causale = assign(:causale, stub_model(Causale,
      :causale => "MyString",
      :magazzino => "MyString",
      :movimento => "MyString"
    ))
  end

  it "renders the edit causale form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => causali_path(@causale), :method => "post" do
      assert_select "input#documento_causale", :name => "causale[causale]"
      assert_select "input#causale_magazzino", :name => "causale[magazzino]"
      assert_select "input#causale_movimento", :name => "causale[movimento]"
    end
  end
end
