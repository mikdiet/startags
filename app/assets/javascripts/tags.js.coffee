$ ->
  $('.js-tags input').select2
    tags: true
    tokenSeparators: [",", " "]
    width: '100%'

  $('.js-tags').on 'click', ->
    $(this).find('input').select2('open')

  $('.js-tags input').on 'change', (e) ->
    id = $(e.target).data('id')
    if e.added
      $.post "/stars/#{ id }/tag/#{ e.added.id }"
    if e.removed
      $.post "/stars/#{ id }/tag/#{ e.removed.id }",
        _method: 'delete'
