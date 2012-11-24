require "spec_helper"

describe AppuntoEventsController do
  describe "routing" do

    it "routes to #index" do
      get("/appunto_events").should route_to("appunto_events#index")
    end

    it "routes to #new" do
      get("/appunto_events/new").should route_to("appunto_events#new")
    end

    it "routes to #show" do
      get("/appunto_events/1").should route_to("appunto_events#show", :id => "1")
    end

    it "routes to #edit" do
      get("/appunto_events/1/edit").should route_to("appunto_events#edit", :id => "1")
    end

    it "routes to #create" do
      post("/appunto_events").should route_to("appunto_events#create")
    end

    it "routes to #update" do
      put("/appunto_events/1").should route_to("appunto_events#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/appunto_events/1").should route_to("appunto_events#destroy", :id => "1")
    end

  end
end
