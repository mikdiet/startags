class StarUpdate
  constructor: (@el) ->
    @$('.js-can-update .btn').on 'click', @update
    @progressBar = @$('.js-update-progress')
    @start() unless @progressBar.hasClass('hidden')
    @$('.js-tooltip').tooltip()

  $: (selector) ->
    @el.find selector

  update: (e) =>
    e.stopPropagation()
    @$('.js-can-update').addClass('hidden')
    @progressBar.removeClass('hidden')
    $.ajax
      type: 'post'
      url: '/stars/update_all'
      dataType: 'json'
      success: @afterUpdate

  afterUpdate: (data) =>
    if data
      @showWaiting(data)
    else
      @start()

  showWaiting: (time) ->
      @progressBar.addClass('hidden')
      @$('.js-cannot-update').removeClass('hidden').find('.js-tooltip').
          attr('title', "You can update in #{ (parseFloat(time) / 60).toFixed() } minutes")

  start: ->
    @timer = 0
    @progress = 0
    @step = 1
    setTimeout(@tick, 100)

  tick: =>
    @timer += 100
    @progress += @step
    fProgress = @progress.toFixed()
    @progressBar.find('.progress-bar').attr('aria-valuenow', fProgress).css('width', "#{fProgress}%")

    if @timer % 5000 == 0
      @step /= 2
      $.ajax
        url: '/stars/update_progress'
        dataType: 'json'
        success: (data) =>
          if data
            # @showWaiting(data)
            Turbolinks.visit document.URL
          else
            setTimeout(@tick, 100)
    else
      setTimeout(@tick, 100)

$ ->
  new StarUpdate $('.js-update')
