require "spec_helper"

describe DocumentiController do
  describe "routing" do

    it "routes to #index" do
      get("/documenti").should route_to("documenti#index")
    end

    it "routes to #new" do
      get("/documenti/new").should route_to("documenti#new")
    end

    it "routes to #show" do
      get("/documenti/1").should route_to("documenti#show", :id => "1")
    end

    it "routes to #edit" do
      get("/documenti/1/edit").should route_to("documenti#edit", :id => "1")
    end

    it "routes to #create" do
      post("/documenti").should route_to("documenti#create")
    end

    it "routes to #update" do
      put("/documenti/1").should route_to("documenti#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/documenti/1").should route_to("documenti#destroy", :id => "1")
    end

  end
end
