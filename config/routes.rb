Rails.application.routes.draw do

  # home page to Trips Index page 
  root "trips#index"
  # Routes for the Journal resource:

  # CREATE
  post("/insert_journal", { :controller => "journals", :action => "create" })

  # READ
  get("/journals", { :controller => "journals", :action => "index" })

  get("/journals/:path_id", { :controller => "journals", :action => "show" })

  # UPDATE

  post("/modify_journal/:path_id", { :controller => "journals", :action => "update" })

  # DELETE
  get("/delete_journal/:path_id", { :controller => "journals", :action => "destroy" })

  #------------------------------

  # Routes for the Membership resource:

  # CREATE
  post("/insert_membership", { :controller => "memberships", :action => "create" })

  # READ
  get("/memberships", { :controller => "memberships", :action => "index" })

  get("/memberships/:path_id", { :controller => "memberships", :action => "show" })

  # UPDATE

  post("/modify_membership/:path_id", { :controller => "memberships", :action => "update" })

  # DELETE
  get("/delete_membership/:path_id", { :controller => "memberships", :action => "destroy" })

  #------------------------------

  # Routes for the Activity resource:

  # CREATE
  post("/insert_activity", { :controller => "activities", :action => "create" })

  # READ
  get("/activities", { :controller => "activities", :action => "index" })

  get("/activities/:path_id", { :controller => "activities", :action => "show" })

  # UPDATE

  post("/modify_activity/:path_id", { :controller => "activities", :action => "update" })

  # DELETE
  get("/delete_activity/:path_id", { :controller => "activities", :action => "destroy" })

  #------------------------------

  # Routes for the Day resource:

  # CREATE
  post("/insert_day", { :controller => "days", :action => "create" })

  # READ
  get("/days", { :controller => "days", :action => "index" })

  get("/days/:path_id", { :controller => "days", :action => "show" })

  # UPDATE

  post("/modify_day/:path_id", { :controller => "days", :action => "update" })

  # DELETE
  get("/delete_day/:path_id", { :controller => "days", :action => "destroy" })

  #------------------------------

  # Routes for the Trip resource:

  # CREATE
  post("/insert_trip", { :controller => "trips", :action => "create" })

  # READ
  get("/trips", { :controller => "trips", :action => "index" })

  get("/trips/:path_id", { :controller => "trips", :action => "show" })

  # UPDATE

  post("/modify_trip/:path_id", { :controller => "trips", :action => "update" })

  # DELETE
  get("/delete_trip/:path_id", { :controller => "trips", :action => "destroy" })

  #------------------------------

  devise_for :users
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
