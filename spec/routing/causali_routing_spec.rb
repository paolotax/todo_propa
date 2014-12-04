require "spec_helper"

describe CausaliController do
  describe "routing" do

    it "routes to #index" do
      get("/causali").should route_to("causali#index")
    end

    it "routes to #new" do
      get("/causali/new").should route_to("causali#new")
    end

    it "routes to #show" do
      get("/causali/1").should route_to("causali#show", :id => "1")
    end

    it "routes to #edit" do
      get("/causali/1/edit").should route_to("causali#edit", :id => "1")
    end

    it "routes to #create" do
      post("/causali").should route_to("causali#create")
    end

    it "routes to #update" do
      put("/causali/1").should route_to("causali#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/causali/1").should route_to("causali#destroy", :id => "1")
    end

  end
end
