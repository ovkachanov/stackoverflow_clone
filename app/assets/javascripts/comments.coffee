$ ->
  $('.create-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId')
    $('form#create-comment-' + commentable_id).show()
