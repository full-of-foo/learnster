do ($, Backbone, Marionette, _) ->


  _.extend Backbone.Marionette.Application::,

    _userRoutes:
        shared: [
          /^organisation\/(\d+)\/students$/,
          /^login$/,
          /^statistics$/
        ]

        student: [

        ],

        orgAdmin: [
          /^organisation\/(\d+)\/admins$/,
          /^student\/(\d+)\/edit$/,
          /^org_admin\/(\d+)\/edit$/,
          /^organisation\/(\d+)\/edit$/,
          /^statistic\/(.+)\/(.+)-trend\/(\d+)$/,
          /^organisation\/(\d+)\/notifications$/
        ],

        appAdmin: [
          /^organisations$/,
          /^students$/,
          /^admins$/
        ]

    getAppAdminRoutes: ->
      _.flatten(@_userRoutes)

    getStudentRoutes: ->
      @_userRoutes.shared.concat(@_userRoutes.student)

    getOrgAdminRoutes: ->
      @getStudentRoutes()
        .concat(@_userRoutes.orgAdmin)

    isRouteMatching: (validRoutes, route) ->
      ((validRoutes.filter (reg) -> reg.test(route)).length > 0)

    isValidRoute: (user, route) ->
      switch user.get('type')
        when "AppAdmin" then isValid = @isRouteMatching(@getAppAdminRoutes(), route)
        when "OrgAdmin" then isValid = @isRouteMatching(@getOrgAdminRoutes(), route)
        when "Student"  then isValid = @isRouteMatching(@getStudentRoutes(), route)
        else throw new Error "User supplied does not have correct type"
      isValid









