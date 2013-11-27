(function( globals ) {

  "use strict";

  var Editor = globals.Editor, Plain;

  Plain = function Plain(editor) {
    this.editor = editor;
  };

  Plain.prototype.refresh = function refresh() {
    var data = [
      "<pre class='plain'><code>",
      Plain.escapeHtml(this.editor.elements.textarea.val()),
      "</code></pre>"
    ].join('');

    this.editor.elements.preview.html(data);
  };

  Plain.entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  Plain.escapeHtml = function escapeHtml(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
      return Plain.entityMap[s];
    });
  };

  Editor.languages["plain"] = Plain;

}( window ))
