app.controller 'FeedController', (
  $scope,
  $state,
  $ionicPlatform,
  IntervalsService,
  UserServicesService,
  BookingService,
  UPDATE_LOADED_SERVICES_INTERVAL
) ->
  new class FeedController
    constructor: ->
      @bindListeners()

      $ionicPlatform.ready =>
        @refreshServices()

    bindListeners: ->
      $scope.$on('bookEvent', (_, data) =>
        BookingService.book(data.event).then (response) =>
          @reloadService(response.service, data.index) if response
      )

      IntervalsService.start(UPDATE_LOADED_SERVICES_INTERVAL, 30000, @updateLoadedServices)

    refreshServices: ->
      @currentPage = 1
      @loadServices((response) =>
        @services = response.services
        @anyMoreServices = response.more

        $scope.$broadcast('scroll.refreshComplete')
      )

    loadMoreServices: ->
      @currentPage++
      @loadServices((response) =>
        @services = @services.concat(response.services)
        @anyMoreServices = response.more

        $scope.$broadcast('scroll.infiniteScrollComplete')
      )

    loadServices: (handleResponse) ->
      params = { per_page: 3, page: @currentPage }

      UserServicesService.findWithGet(params).then(handleResponse, $scope.error)

    reloadService: (service, index) =>
      @services[index].nearest_event = service.nearest_event

    updateLoadedServices: =>
      return unless $scope.isAppInForeground

      return unless @services

      ids = @services.map (item) -> item.id

      UserServicesService
        .findWithGet(action: 'show_selected', 'ids[]': ids)
        .then(@replaceNearestEvents)
        .catch($scope.error)

    replaceNearestEvents: (response) =>
      @replaceNearestEvent(service, response.services) for service in @services

    replaceNearestEvent: (service, updatedServices) ->
      updatedService = updatedServices[service.id]

      return service.nearest_event = null unless updatedService

      service.nearest_event =  updatedService.nearest_event

    goTo: (state, params) ->
      $state.go(state, params)
