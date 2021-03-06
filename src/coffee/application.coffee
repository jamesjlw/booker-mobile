Raven
  .config(
    'https://f02365b72b7e42d38235bfe73849e651@sentry.io/129218',
    release: '@@app_version',
    environment: '@@env'
  )
  .install();

app = angular.module(
  'timespex',
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
    'monospaced.elastic',
    'ngCordova.plugins.nativeStorage',
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
    translateFilter,
    Navigator,
    AjaxInterceptor,
    PushNotificationService,
    AuthService,
    LoggerService,
    AppUpdateService,
    ToastService,
    GoogleAnalyticsService,
    AUTH_EVENTS,
    SERVER_EVENTS,
    EVENTS
  ) ->
    $ionicPlatform.ready =>
      LoggerService.init()
      GoogleAnalyticsService.init()
      AppUpdateService.checkForUpdate()
      PushNotificationService.registerToken()

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

    $rootScope.$on('$stateChangeStart', (event, next, nextParams, fromState) ->
      GoogleAnalyticsService.trackEvent('Navigation', 'State Changed To' , next.name)
      GoogleAnalyticsService.trackView(next.name)

      if !AuthService.isAuthenticated()
        unless next.name in ['login', 'signup', 'terms']
          LoggerService
            .sendMessage("App logged out from #{fromState.name} to #{next.name}", level: 'warning')

          event.preventDefault()

          $state.transitionTo('login')
    )

    $rootScope.isAppInForeground = true

    $ionicPlatform.on 'resume', ->
      $rootScope.$emit(EVENTS.UPDATE_CURRENT_USER) if AuthService.isAuthenticated()

      AppUpdateService.checkForUpdate()

      $rootScope.isAppInForeground = true

    $ionicPlatform.on 'pause', ->
      $rootScope.isAppInForeground = false

    $rootScope.$on(AUTH_EVENTS.notAuthorized, ->
      $state.go('login')
      $auth.deleteData('auth_headers')

      ToastService.error(translateFilter('errors.something_wrong'))
    )

    $rootScope.error = (message) ->
      ToastService.error(translateFilter('errors.something_wrong'))

    $rootScope.navigator = Navigator

    $rootScope.stateIs = (state) ->
      $state.is(state)

    $rootScope.isAndroid = ->
      ionic.Platform.isAndroid()

    AjaxInterceptor.run()

    return
)
