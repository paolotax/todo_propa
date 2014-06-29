require 'spec_helper'

describe "editori/edit" do
  before(:each) do
    @editore = assign(:editore, stub_model(Editore,
      :nome => "MyString",
      :gruppo => "MyString",
      :codice => "MyString"
    ))
  end

  it "renders the edit editore form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => editori_path(@editore), :method => "post" do
      assert_select "input#editore_nome", :name => "editore[nome]"
      assert_select "input#editore_gruppo", :name => "editore[gruppo]"
      assert_select "input#editore_codice", :name => "editore[codice]"
    end
  end
end
