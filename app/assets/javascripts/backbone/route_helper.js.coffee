do (Learnster, $, Backbone, Marionette, _) ->

  _.extend Backbone.Marionette.Application::,

    _userRoutes:
        shared: [
          /^organisation\/(.+?)\/students$/,
          /^organisation\/(.+?)\/admins$/,
          /^student\/(.+?)\/edit$/,
          /^org_admin\/(.+?)\/edit$/,
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
          /^course_section\/(.+?)\/show$/,
          /^deliverable\/(.+?)\/show$/
        ],

        orgAdmin: [
          /^organisation\/(.+?)\/admins$/,
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
          /^course_section\/(.+?)\/show$/,
          /^deliverable\/(.+?)\/show$/,
          /^deliverable\/(.+?)\/edit$/
        ],

        appAdmin: [
          /^organisations$/,
          /^students$/,
          /^admins$/,
          /^notifications$/
        ]

    setTitle: (route) ->
      switch true
        when /students$/.test(route)
          $('title').html('Students')
          break
        when /^student/.test(route)
          $('title').html('Student')
          break
        when /admins$/.test(route)
          $('title').html('Administrators')
          break
        when /^org_admin/.test(route)
          $('title').html('Administrator')
          break
        when /courses$/.test(route)
          $('title').html('Courses')
          break
        when /course\//.test(route)
          $('title').html('Course')
          break
        when /^deliverable\/(.+?)\/show$/.test(route)
          $('title').html('Deliverable')
          break
        when /modules$/.test(route)
          $('title').html('Modules')
          break
        when /^module\/(.+?)\/supplement\/(.+?)\/wiki\/(.+?)$/.test(route)
          $('title').html('Wiki')
          break
        when /^module\/(.+?)\/supplement\/(.+?)\/show$/.test(route)
          $('title').html('Supplement')
          break
        when /module\//.test(route)
          $('title').html('Module')
          break
        when /notifications$/.test(route)
          $('title').html('Notifications')
          break
        when /statistic/.test(route)
          $('title').html('Statistics')
          break
        when /^course_section/.test(route)
          $('title').html('Course Section')
          break
        when /my_settings$/.test(route)
          $('title').html('Settings')
          break
        when /404$/.test(route)
          $('title').html('Page Not Found')
          break
        when /^organisation\/(.+?)\/dashboard$/.test(route)
          $('title').html('Dashboard')
          break
        when /^login$/.test(route)
          $('title').html('Sign in | Learnster')
          break
        when /^about$/.test(route)
          $('title').html('About | Learnster')
          break
        when /^testimonials$/.test(route)
          $('title').html('Testimonials | Learnster')
          break
        when /^signu(.+)$/.test(route)
          $('title').html('Sign Up | Learnster')
          break
        else
          $('title').html('Learnster')
          break

    getAllRoutes: ->
      _.flatten(@_userRoutes)

    getStudentRoutes: ->
      @_userRoutes.shared.concat(@_userRoutes.student)

    getOrgAdminRoutes: ->
      @getStudentRoutes()
        .concat(@_userRoutes.orgAdmin)

    isRouteMatching: (validRoutes, route) ->
      ((validRoutes.filter (reg) -> reg.test(route)).length > 0)

    isPermittedRoute: (user, route) ->
      if user instanceof Learnster.Entities.AppAdmin then isValid = @isRouteMatching(@getAllRoutes(), route)
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
