require 'spec_helper'

describe "propa2014s/new" do
  before(:each) do
    assign(:propa2014, stub_model(Propa2014,
      :cliente_id => 1,
      :kit_123 => "MyString",
      :nr_123 => 1,
      :kit_45 => "MyString",
      :nr_45 => 1,
      :kit_123_ing => "MyString",
      :nr_45_ing => 1,
      :kit_123_rel => "MyString",
      :nr_123_rel => 1,
      :kit_45_rel => "MyString",
      :nr_45_rel => 1,
      :vac_1 => "MyString",
      :vac_2 => "MyString",
      :vac_3 => "MyString",
      :vac_4 => "MyString",
      :vac_5 => "MyString"
    ).as_new_record)
  end

  it "renders new propa2014 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => propa2014s_path, :method => "post" do
      assert_select "input#propa2014_cliente_id", :name => "propa2014[cliente_id]"
      assert_select "input#propa2014_kit_123", :name => "propa2014[kit_123]"
      assert_select "input#propa2014_nr_123", :name => "propa2014[nr_123]"
      assert_select "input#propa2014_kit_45", :name => "propa2014[kit_45]"
      assert_select "input#propa2014_nr_45", :name => "propa2014[nr_45]"
      assert_select "input#propa2014_kit_123_ing", :name => "propa2014[kit_123_ing]"
      assert_select "input#propa2014_nr_45_ing", :name => "propa2014[nr_45_ing]"
      assert_select "input#propa2014_kit_123_rel", :name => "propa2014[kit_123_rel]"
      assert_select "input#propa2014_nr_123_rel", :name => "propa2014[nr_123_rel]"
      assert_select "input#propa2014_kit_45_rel", :name => "propa2014[kit_45_rel]"
      assert_select "input#propa2014_nr_45_rel", :name => "propa2014[nr_45_rel]"
      assert_select "input#propa2014_vac_1", :name => "propa2014[vac_1]"
      assert_select "input#propa2014_vac_2", :name => "propa2014[vac_2]"
      assert_select "input#propa2014_vac_3", :name => "propa2014[vac_3]"
      assert_select "input#propa2014_vac_4", :name => "propa2014[vac_4]"
      assert_select "input#propa2014_vac_5", :name => "propa2014[vac_5]"
    end
  end
end
