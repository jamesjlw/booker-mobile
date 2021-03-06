app.controller 'ServiceSettingsController', (
  $scope,
  service,
  ToastService,
  UserServicesService,
  translateFilter
) ->
    new class ServiceSettingsController
      constructor: ->
        @service = service

      durations: [
          { value: 15, label: '15 min.' }
          { value: 30, label: '30 min.' }
          { value: 45, label: '45 min.' }
          { value: 60, label: '1 val.' }
          { value: 90, label: '1 val. 30 min.' }
          { value: 120, label: '2 val.' }
      ]

      save: (form) ->
        return unless form.$valid

        UserServicesService.update(service).then(@afterSave, $scope.error)

      afterSave: (response) =>
        $scope.navigator.home(reload: true)

      togglePublication: (form) ->
        form.$setSubmitted(true)

        return @resetToggle() if form.$invalid

        return UserServicesService.unpublish(service.id) unless service.published

        UserServicesService.publish(service.id)
          .then(@togglePublicationSuccess)
          .catch(@togglePublicationFail)

      togglePublicationSuccess: (response) =>
        ToastService.show(translateFilter('service.settings.visible_now'), 'bottom', false, 3000)

      togglePublicationFail: (response) =>
        @resetToggle()

        return $scope.error() unless response.data.service

        ToastService.error(response.data.errors[0], 'bottom', false, 3000);

      resetToggle: ->
        service.published = 0
