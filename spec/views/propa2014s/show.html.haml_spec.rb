require 'spec_helper'

describe "propa2014s/show" do
  before(:each) do
    @propa2014 = assign(:propa2014, stub_model(Propa2014,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Kit 123/)
    rendered.should match(/2/)
    rendered.should match(/Kit 45/)
    rendered.should match(/3/)
    rendered.should match(/Kit 123 Ing/)
    rendered.should match(/4/)
    rendered.should match(/Kit 123 Rel/)
    rendered.should match(/5/)
    rendered.should match(/Kit 45 Rel/)
    rendered.should match(/6/)
    rendered.should match(/Vac 1/)
    rendered.should match(/Vac 2/)
    rendered.should match(/Vac 3/)
    rendered.should match(/Vac 4/)
    rendered.should match(/Vac 5/)
  end
end
