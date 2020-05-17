angular.module('doubtfire.home.states.home', [])

.config((headerServiceProvider) ->
  homeStateData =
    url: "/home?notifications"
    views:
      main:
        controller: "HomeCtrl"
        templateUrl: "home/states/home/home.tpl.html"
    data:
      pageTitle: "_Home_"
      roleWhitelist: ['Student', 'Tutor', 'Convenor', 'Admin']
  headerServiceProvider.state 'home', homeStateData
)

.controller("HomeCtrl", ($scope, $state, $timeout, User, Unit, DoubtfireConstants, currentUser, unitService, projectService, $rootScope, analyticsService, dateService, UserNotificationSettingsModal) ->
  analyticsService.event 'Home', 'Viewed Home page'

  # Get the confugurable, external name of Doubtfire
  $scope.externalName = DoubtfireConstants.ExternalName

  $scope.userFirstName = currentUser.profile.nickname or currentUser.profile.first_name
  $scope.showDate = dateService.showDate

  hasRoles = false
  hasProjects = false

  #
  # If this is a new wizard show the new user wizard
  # state instead
  #
  testForNewUserWizard = ->
    firstTimeUser     = currentUser.profile.has_run_first_time_setup is false
    userHasNotOptedIn = currentUser.profile.opt_in_to_research is null

    showNewUserWizard = firstTimeUser or userHasNotOptedIn
    userHasNotOptedIn = userHasNotOptedIn and not firstTimeUser

    if showNewUserWizard
      $state.go 'new-user-wizard', { optInOnly: userHasNotOptedIn }

    showNewUserWizard

  testForStateChanges = ->
    showingWizard = testForNewUserWizard()

  timeoutPromise = $timeout((-> $scope.showSpinner = true), 2000)
  unitService.getUnitRoles (roles) ->
    $scope.unitRoles = roles
    hasRoles = true
    projectService.getProjects false, (projects) ->
      $scope.projects = projects
      $scope.showSpinner = false
      $scope.dataLoaded = true
      hasProjects = true
      testForStateChanges()
      $timeout.cancel(timeoutPromise)

  checkEnrolled = ->
    return if !$scope.unitRoles? or !$scope.projects?
    $scope.notEnrolled = ->
      # Not enrolled if a tutor and no unitRoles
      ($scope.unitRoles.length is 0 and currentUser.role is 'Tutor') or
      # Not enrolled if a student and no projects
      ($scope.projects.length is 0 and currentUser.role is 'Student')

  $scope.$watch 'projects', checkEnrolled
  $scope.$watch 'unitRoles', checkEnrolled

  if currentUser.role isnt 'Student'
    Unit.query (units) ->
      $scope.units = units

  $scope.unit = (unitId) ->
    _.find($scope.units, {id: unitId})

  $scope.currentUser = currentUser

  if $state.params?.notifications? && $state.params?.notifications == "true"
    UserNotificationSettingsModal.show currentUser?.profile

)
