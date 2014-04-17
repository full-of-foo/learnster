@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

  API =
    getDockerView: (userType) ->
      switch userType
        when "AppAdmin" then links = App.request "AppAdmin:docker:entities"
        when "OrgAdmin" then links = App.request "OrgAdmin:docker:entities"
        when "Student" then links =  App.request "Student:docker:entities"
        when "Login" then links =    App.request "Login:docker:entities"

      new List.Docker
        collection:links


  App.reqres.setHandler "get:header:dock:view", ->
    user = App.request "get:current:user"
    userType = if Object(user) not instanceof Boolean then user.get('type') else "Login"
    API.getDockerView(userType)
