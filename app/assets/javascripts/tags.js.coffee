$ ->
  $('.js-tags input').select2
    tags: true
    tokenSeparators: [",", " "]
    width: '100%'
    initSelection: (e, callback) ->
      data = []
      $(e.val().split(",")).each ->
        data.push
          id: this
          text: this
      callback(data)
    createSearchChoice: (term) ->
      valid_term = term.replace /[\s,]/, ''
      {id: valid_term, text: valid_term}
    query: (q) ->
      # id = q.element.data('id')
      $.ajax
        url: '/tags/suggest'
        data:
          q: q.term
        dataType: 'json'
        success: (data) =>
          q.callback
            results: data

  $('.js-tags').on 'click', ->
    $(this).find('input').select2('open')

  $('.js-tags input').on 'change', (e) ->
    id = $(e.target).data('id')
    if e.added
      $.post "/stars/#{ id }/tag/#{ e.added.id }"
    if e.removed
      $.post "/stars/#{ id }/tag/#{ e.removed.id }",
        _method: 'delete'
