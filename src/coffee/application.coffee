Raven
  .config('https://f02365b72b7e42d38235bfe73849e651@sentry.io/129218', release: '@@app_version')
  .install();

app = angular.module(
  'booker',
  [
    'ngRaven',
    'ionic',
    'ngCordova',
    'ngResource',
    'angularMoment',
    'ion-datetime-picker',
    'ionic-toast',
    'ionic-ajax-interceptor',
    'ionicLazyLoad',
    'ng-token-auth',
    'ngMessages',
    'ionic.cloud',
    'ngAnimate',
    'pascalprecht.translate',
    @@templates
  ]
)

Raven.context( =>
  app.run (
    $rootScope,
    $state,
    $ionicPlatform,
    $ionicPopup,
    $log,
    $auth,
    $translate,
    Navigator,
    AjaxInterceptor,
    NotificationService,
    AuthService,
    LoggerService,
    AUTH_EVENTS,
    SERVER_EVENTS,
    EVENTS
  ) ->
    $ionicPlatform.ready =>
      LoggerService.init()

      NotificationService.registerToken()

      if ionic.Platform.isIOS()
        cordova.plugins.notification.local.registerPermission (granted) ->
          console.log("Notifications granted: #{granted}")
      if window.cordova and window.cordova.plugins.Keyboard
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);

        cordova.plugins.Keyboard.disableScroll(true);

      if window.StatusBar
        StatusBar.styleDefault();

      setTimeout(
        -> navigator.splashscreen.hide()
      , 300)

    $rootScope.isAppInForeground = true

    $ionicPlatform.on 'resume', ->
      $rootScope.$emit(EVENTS.UPDATE_CURRENT_USER) if AuthService.isAuthenticated()

      $rootScope.isAppInForeground = true

    $ionicPlatform.on 'pause', ->
      $rootScope.isAppInForeground = false

    $rootScope.$on('$stateChangeStart', (event, next, nextParams, fromState) ->
      if !AuthService.isAuthenticated()
        unless next.name in ['login', 'signup', 'terms']
          event.preventDefault()
          $state.transitionTo('login')
    )

    $rootScope.$on(AUTH_EVENTS.notAuthorized, ->
      $state.go('login')
      $auth.deleteData('auth_headers')

      $ionicPopup.alert
        template: $translate('errors.unauthorized'))

    $rootScope.$on SERVER_EVENTS.not_found, ->
      $ionicPopup.alert
        title: $translate('errors.something_wrong')
        template: $translate('errors.try_login_again')

    $rootScope.error = (message) ->
      $ionicPopup.alert(template: $translate('errors.something_wrong'))

    $rootScope.navigator = Navigator

    $rootScope.stateIs = (state) ->
      $state.is(state)

    $rootScope.isAndroid = ->
      ionic.Platform.isAndroid()

    AjaxInterceptor.run()

    return
)
