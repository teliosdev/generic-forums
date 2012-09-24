$( ()->
  return unless $("html").hasClass("posts_edit") or $("html").hasClass("posts_new") or $("html").hasClass("posts_index")

  $format_selector = $ "form.for_editor #post_format"
  $editor          = $ ".editor"
  return if $editor.length < 0

  window.editors ||= []
  format = $format_selector.val()

  editor = new Editor($editor, format, {
                      "iconContainer": $editor.parent().children(".high_bar").children(".icon_container"),
                      "output": $editor.parent().children(".output_wrapper")
  })
  window.editors.push editor

  $format_selector.on("change", editor, (event)->
    console.log $(this).val()
    editor.changeSyntax $(this).val()
  )

)
