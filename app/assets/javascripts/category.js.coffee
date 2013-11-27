# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require editor

$ ->
  if $("#post-content").length > 0
    window.editor = new window.Editor(element: $("#post-content"))

  $('pre code').each((i, e)-> hljs.highlightBlock(e));

  MathJax.Hub.Config({
    messageStyle: "none",
    displayAlign: "left",
    tex2jax: {
      inlineMath: ['$$$', '$$$'],
      skipTags: ["script", "noscript", "style", "textarea", "code"],
      ignoreClass: "reply\\-body"
    },
    showMathMenu: false,
    showMathMenuMSIE: false,
    styles: {
      ".MathJax_Display": {
        display: "inline-block !important",
        width: "auto !important",
        margin: "0 !important"
      },
      ".MathJax .noError": {
        color: "#D4744C !important",
        border: "none !important"
        background: "#FFF3CB !important",
        padding: "10px !important"
      }
    }
  })

  MathJax.Hub.Configured()
