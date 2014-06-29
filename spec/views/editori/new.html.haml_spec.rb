require 'spec_helper'

describe "editori/new" do
  before(:each) do
    assign(:editore, stub_model(Editore,
      :nome => "MyString",
      :gruppo => "MyString",
      :codice => "MyString"
    ).as_new_record)
  end

  it "renders new editore form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => editori_path, :method => "post" do
      assert_select "input#editore_nome", :name => "editore[nome]"
      assert_select "input#editore_gruppo", :name => "editore[gruppo]"
      assert_select "input#editore_codice", :name => "editore[codice]"
    end
  end
end
