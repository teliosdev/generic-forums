# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

console.log "Hello World"
# ()->
#  if $(".editor").length > 0
#    console.log "Setting Window.Editors"
#    window.editors = []
#    $(".editor").each (i,v)->
#      syntax = null
#      $v = $(v)
#      if $v.hasClass("editor_markdown")
#        syntax = new MarkdownSyntax()
#      else if $v.hasClass("editor_bbcode")
#        syntax = new BbCodeSyntax()
#      window.editors.push new Editor($v, syntax)
( ()->
	unless $("html").hasClass("home_editor")
		return
	unless $(".editor").length > 0
		return
	window.editors = []
	$(".editor").each (_,v)->
		$v = $(v)
		window.editors.push new window.Editor($v, $v.data('format'))
).call(this)
