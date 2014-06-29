require "spec_helper"

describe EditoriController do
  describe "routing" do

    it "routes to #index" do
      get("/editori").should route_to("editori#index")
    end

    it "routes to #new" do
      get("/editori/new").should route_to("editori#new")
    end

    it "routes to #show" do
      get("/editori/1").should route_to("editori#show", :id => "1")
    end

    it "routes to #edit" do
      get("/editori/1/edit").should route_to("editori#edit", :id => "1")
    end

    it "routes to #create" do
      post("/editori").should route_to("editori#create")
    end

    it "routes to #update" do
      put("/editori/1").should route_to("editori#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/editori/1").should route_to("editori#destroy", :id => "1")
    end

  end
end
