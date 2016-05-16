# app.factory('UserService', ($resource, API_URL) ->
#   $resource("#{API_URL}/api/v1/services/:id.json", { id: '@id' }
#     update: { method:'PUT' }
#   )
# )
class UserService
  'use strict'

  constructor: ($resource, API_URL) ->
    @$r = $resource("#{API_URL}/api/v1/services/:id.json", { id: '@id' }
      update: { method:'PUT' }
    )

    @$events = $resource("#{API_URL}/api/v1/services/:service_id/events.json",{ service_id: '@service_id' })

    return this

app.factory('UserService', UserService)
