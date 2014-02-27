do (Learnster, $, Backbone, Marionette, _) ->

  _.extend Backbone.Marionette.Application::,

    _userRoutes:
        shared: [
          /^organisation\/(.+?)\/students$/,
          /^organisation\/(.+?)\/admins$/,
          /^login$/,
          /^about$/,
          /^testimonials$/,
          /^signu(.+)$/,
          /^statistics$/,
          /^404$/
        ]

        student: [
          /^organisation\/(.+?)\/admins$/,
          /^statistic\/(.+)\/(.+)\/(.+)$/,
          /^organisation\/(.+?)\/notifications$/,
          /^organisation\/(.+?)\/dashboard$/,
          /^organisation\/(.+?)\/my_students$/,
          /^organisation\/(.+?)\/my_admins$/,
          /^organisation\/(.+?)\/my_courses$/,
          /^organisation\/(.+?)\/my_modules$/,
          /^organisation\/(.+?)\/my_settings$/,
          /^course\/(.+?)\/show$/,
          /^module\/(.+?)\/show$/,
          /^module\/(.+?)\/supplement\/(.+?)\/show$/,
          /^course_section\/(.+?)\/show$/
        ],

        orgAdmin: [
          /^organisation\/(.+?)\/admins$/,
          /^student\/(.+?)\/edit$/,
          /^org_admin\/(.+?)\/edit$/,
          /^organisation\/(.+?)\/edit$/,
          /^statistic\/(.+)\/(.+)\/(.+)$/,
          /^organisation\/(.+?)\/notifications$/,
          /^organisation\/(.+?)\/dashboard$/,
          /^organisation\/(.+?)\/courses$/,
          /^organisation\/(.+?)\/my_courses$/,
          /^organisation\/(.+?)\/modules$/,
          /^organisation\/(.+?)\/my_modules$/,
          /^organisation\/(.+?)\/my_students$/,
          /^organisation\/(.+?)\/my_admins$/,
          /^organisation\/(.+?)\/my_settings$/,
          /^course\/(.+?)\/edit$/,
          /^course\/(.+?)\/show$/,
          /^module\/(.+?)\/edit$/,
          /^module\/(.+?)\/show$/,
          /^module\/(.+?)\/supplement\/(.+?)\/show$/,
          /^course_section\/(.+?)\/edit$/,
          /^course_section\/(.+?)\/show$/
        ],

        appAdmin: [
          /^organisations$/,
          /^students$/,
          /^admins$/,
          /^notifications$/
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

    isPermittedRoute: (user, route) ->
      if user instanceof Learnster.Entities.AppAdmin then isValid = @isRouteMatching(@getAppAdminRoutes(), route)
      if user instanceof Learnster.Entities.OrgAdmin then isValid = @isRouteMatching(@getOrgAdminRoutes(), route)
      if user instanceof Learnster.Entities.Student  then isValid = @isRouteMatching(@getStudentRoutes(), route)
      isValid

    _isSideRoute: (route) ->
      ((@_getSideRoutes().filter (reg) -> reg.test(route)).length > 0)

    _getSideRoutes: ->
      [ /^login$/, /^signu(.+)$/, /^organisations$/, /^admins$/, /^students$/,
        /^organisation\/(.+?)\/dashboard$/, /^organisation\/(.+?)\/admins$/,
        /^organisation\/(.+?)\/students$/, /^organisation\/(.+?)\/my_students$/,
        /^organisation\/(.+?)\/my_admins$/, /^organisation\/(.+?)\/my_courses$/,
        /^organisation\/(.+?)\/my_modules$/]

    sideItemIdForRoute: (route) ->
      id = "side-item-sign-in"      if /^login$/.test(route)
      id = "side-item-sign-up"      if /^signu(.+)$/.test(route)
      id = "side-item-orgs"         if /^organisations$/.test(route)
      id = "side-item-app-admins"   if /^admins$/.test(route)
      id = "side-item-app-students" if /^students$/.test(route)
      id = "side-item-dash"         if /^organisation\/(.+?)\/dashboard$/.test(route)
      id = "side-item-all-admins"   if /^organisation\/(.+?)\/admins$/.test(route)
      id = "side-item-all-students" if /^organisation\/(.+?)\/students$/.test(route)
      id = "side-item-my-administrators" if /^organisation\/(.+?)\/my_admins$/.test(route)
      id = "side-item-my-students"  if /^organisation\/(.+?)\/my_students$/.test(route)
      id = "side-item-my-courses"   if /^organisation\/(.+?)\/my_courses$/.test(route)
      id = "side-item-my-modules"   if /^organisation\/(.+?)\/my_modules$/.test(route)
      id
