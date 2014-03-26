require 'spec_helper'

describe "propa2014s/index" do
  before(:each) do
    assign(:propa2014s, [
      stub_model(Propa2014,
        :cliente_id => 1,
        :kit_123 => "Kit 123",
        :nr_123 => 2,
        :kit_45 => "Kit 45",
        :nr_45 => 3,
        :kit_123_ing => "Kit 123 Ing",
        :nr_45_ing => 4,
        :kit_123_rel => "Kit 123 Rel",
        :nr_123_rel => 5,
        :kit_45_rel => "Kit 45 Rel",
        :nr_45_rel => 6,
        :vac_1 => "Vac 1",
        :vac_2 => "Vac 2",
        :vac_3 => "Vac 3",
        :vac_4 => "Vac 4",
        :vac_5 => "Vac 5"
      ),
      stub_model(Propa2014,
        :cliente_id => 1,
        :kit_123 => "Kit 123",
        :nr_123 => 2,
        :kit_45 => "Kit 45",
        :nr_45 => 3,
        :kit_123_ing => "Kit 123 Ing",
        :nr_45_ing => 4,
        :kit_123_rel => "Kit 123 Rel",
        :nr_123_rel => 5,
        :kit_45_rel => "Kit 45 Rel",
        :nr_45_rel => 6,
        :vac_1 => "Vac 1",
        :vac_2 => "Vac 2",
        :vac_3 => "Vac 3",
        :vac_4 => "Vac 4",
        :vac_5 => "Vac 5"
      )
    ])
  end

  it "renders a list of propa2014s" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Kit 123".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Kit 45".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Kit 123 Ing".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Kit 123 Rel".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Kit 45 Rel".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Vac 1".to_s, :count => 2
    assert_select "tr>td", :text => "Vac 2".to_s, :count => 2
    assert_select "tr>td", :text => "Vac 3".to_s, :count => 2
    assert_select "tr>td", :text => "Vac 4".to_s, :count => 2
    assert_select "tr>td", :text => "Vac 5".to_s, :count => 2
  end
end
