require "spec_helper"

describe Propa2014sController do
  describe "routing" do

    it "routes to #index" do
      get("/propa2014s").should route_to("propa2014s#index")
    end

    it "routes to #new" do
      get("/propa2014s/new").should route_to("propa2014s#new")
    end

    it "routes to #show" do
      get("/propa2014s/1").should route_to("propa2014s#show", :id => "1")
    end

    it "routes to #edit" do
      get("/propa2014s/1/edit").should route_to("propa2014s#edit", :id => "1")
    end

    it "routes to #create" do
      post("/propa2014s").should route_to("propa2014s#create")
    end

    it "routes to #update" do
      put("/propa2014s/1").should route_to("propa2014s#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/propa2014s/1").should route_to("propa2014s#destroy", :id => "1")
    end

  end
end
