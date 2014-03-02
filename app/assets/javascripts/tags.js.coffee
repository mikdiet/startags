$ ->
  $('.js-tags input').select2
    tags: true
    tokenSeparators: [",", " "]
    width: '100%'

  $('.js-tags').on 'click', ->
    $(this).find('input').select2('open')
