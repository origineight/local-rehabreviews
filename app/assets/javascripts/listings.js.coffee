# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.add_comment').click ->
    $comment_form = $(this).parents('.review-body').next().next()
    if $comment_form.hasClass('hidden')
      $comment_form.removeClass 'hidden'
      $comment_form.find('#comment_initial').focus()
    else
      $comment_form.addClass 'hidden'
    return
  # The slider being synced must be initialized first
  $('#profile-thumb-slider').flexslider
    animation: 'slide'
    controlNav: false
    animationLoop: false
    slideshow: false
    itemWidth: 100
    itemMargin: 10
    minItems: 1
    maxItems: 8
    asNavFor: '#profile-slider'
  $('#profile-slider').flexslider
    animation: 'fade'
    controlNav: false
    directionNav: false
    animationLoop: false
    slideshow: false
    sync: '#profile-thumb-slider'
  return