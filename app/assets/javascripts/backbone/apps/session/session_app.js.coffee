@Learnster.module "SessionApp", (SessionApp, App, Backbone, Marionette, $, _, LearnsterCollab) ->

  class SessionApp.Router extends App.Routers.AppRouter
    appRoutes:
      "login" : "showLogin"
      "signup": "showSignUp"
      "signup/:id/confirm/:code" : "showSignUpFromRegister"


  API =
    showLogin: ->
      new SessionApp.Show.Controller()

    showSignUp: ->
      new SessionApp.Create.Controller()

    showSignUpFromRegister: (admin_id, reg_code) ->
      new SessionApp.Create.Controller
        admin_id: admin_id
        code: reg_code

    getDestroyIconView: ->
      new SessionApp.Destroy.Icon()

    _showOnboaringDialog: (userType = false, adminRole = false) ->
      msg  = @_getOnboardingMsg(userType, adminRole)
      opts =
        headerText: 'Welcome to Learnster!'
        contentText: msg
        primary: false
        secondary:
          text:      "Continue and don't show again"
          cssClass:  'btn btn-success'
          hasDismiss: true
          callback:   ( -> $.cookie('user_onboarded', true) )

      _.delay(( => App.request("show:dialog:box", opts)), 650)


    _getOnboardingMsg: (userType, adminRole) ->
      if userType is "Student"
        msg = '<p>As a student your educators assign you to courses and modules where you can begin learning!</p>'
      else if adminRole is "module_manager"
        msg = '<p>As a module manager you can create and manage your modules and their contents!</p>'
      else if adminRole is "course_manager"
        msg = '<p>As a course manager you can create and manage your modules in addition to managing your courses!</p>'
      else if adminRole is "account_manager"
        msg = '<p>As an account manager you can create and manage all courses, modules, managers and students in your organisation!</p>'
      msg

  App.vent.on "session:created", (currentUser = null) ->
    userType    = currentUser.get('type')
    adminRole   = currentUser.get('role') if userType is "OrgAdmin"
    isOnboarded = $.cookie('user_onboarded') or userType is "AppAdmin"

    API._showOnboaringDialog(userType, adminRole) if not isOnboarded
    App.execute "reset:regions"

  App.vent.on "session:destroyed", (currentUser = null) ->
    App.execute "reset:regions"
    LearnsterCollab.getInstance().stop()

  App.reqres.setHandler "new:destroy:icon:view", ->
    API.getDestroyIconView()

  App.addInitializer ->
    new SessionApp.Router
      controller: API

, LearnsterCollab
