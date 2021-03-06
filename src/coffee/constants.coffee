app.constant('AUTH_EVENTS'
  notAuthenticated: 'auth-not-authenticated'
  notAuthorized: 'auth-not-authorized'
)

app.constant('SERVER_EVENTS'
  not_found: 'not_found'
)

app.constant('USER_ROLES'
  seller: 'admin_role'
  simple: 'public_role'
)

app.constant 'EVENTS',
  UPDATE_CURRENT_USER: 'UPDATE_CURRENT_USER'

app.constant 'EVENT_STATUS',
  FREE: 'free'
  PENDING: 'pending'
  BOOKED: 'booked'

app.constant 'ERROR_TYPES',
  HTTP: 'Http'
  TOKEN: 'Token'
  ANGULAR: 'Angular'

app.constant 'UPDATE_LOADED_SERVICES_INTERVAL', 'update_loaded_services_interval'

app.constant 'API_URL', '@@api_url'

app.constant 'LOCALE', '@@locale'

app.constant 'TRANSLATIONS', @@translations

app.constant 'APP_VERSION', '@@app_version'

app.constant 'APP_CHANNEL', '@@app_channel'

app.constant 'ENVIRONMENT', '@@env'

app.constant 'GA_ID', '@@google_analytics_id'

app.constant('$ionicLoadingConfig', {
  templateUrl: 'templates/components/loading.html'
  noBackdrop: 'false'
});
