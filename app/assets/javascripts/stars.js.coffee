class StarUpdate
  constructor: (@el) ->
    @$('.js-can-update .btn').on 'click', @update

  $: (selector) ->
    @el.find selector

  update: (e) =>
    e.stopPropagation()
    @$('.js-can-update').addClass('hidden')
    @$('.js-update-progress').removeClass('hidden')
    $.ajax
      type: 'post'
      url: '/stars/update_all'
      dataType: 'json'
      success: @after_update

  after_update: (data) =>
    if !data or data == 'OK'
      # TODO progressbar
    else
      @$('.js-update-progress').addClass('hidden')
      @$('.js-cannot-update').removeClass('hidden').find('.btn').text("You can update in #{ (parseFloat(data) / 60).toFixed() } minutes")


$ ->
  new StarUpdate $('.js-update')
