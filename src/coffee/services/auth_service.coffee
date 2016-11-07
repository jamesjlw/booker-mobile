app.factory 'AuthService', ($q, $auth, $ionicHistory, NotificationService, LOCAL_CURRENT_USER_ID) ->
  new class AuthService
    constructor: ->
      @isAuthenticated = $auth.retrieveData('auth_headers') != null

    login: (data) ->
      d = $q.defer()

      $auth.submitLogin(data)
        .then (user) =>
          @isAuthenticated = true

          @storeUserCredentials(user)
          @saveToken()

          d.resolve(user)
        .catch ->
          d.reject('Login failed')

      d.promise

    saveToken: =>
      NotificationService.saveToken()

    logout: ->
      @isAuthenticated = false

      @destroyUserCredentials()
      NotificationService.unregisterToken()
      $ionicHistory.clearCache()

      $auth.signOut()
        .then => console.log('Loggout success')
        .catch -> console.log('Loggout failed')

    signup: (data) ->
      $auth.submitRegistration(data)

    storeUserCredentials: (user) ->
      window.localStorage.setItem(LOCAL_CURRENT_USER_ID, user.id)

    destroyUserCredentials: ->
      window.localStorage.removeItem(LOCAL_CURRENT_USER_ID)
