require 'spec_helper'

describe "editori/show" do
  before(:each) do
    @editore = assign(:editore, stub_model(Editore,
      :nome => "Nome",
      :gruppo => "Gruppo",
      :codice => "Codice"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Nome/)
    rendered.should match(/Gruppo/)
    rendered.should match(/Codice/)
  end
end
