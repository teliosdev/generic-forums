# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$( ()->
  return unless $("html").hasClass("posts_edit") or $("html").hasClass("posts_new")

  $format_selector = $ "form.for_editor #post_format"
  $editor          = $ ".editor"
  return if $editor.length < 0

  window.editors ||= []
  format = $format_selector.val()

  editor = new Editor($editor, format)
  window.editors.push editor

  $format_selector.on("change", editor, (event)->
    console.log $(this).val()
    editor.changeSyntax $(this).val()
  )

)
