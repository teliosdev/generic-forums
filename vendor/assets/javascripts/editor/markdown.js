(function( globals ) {

  "use strict";

  var Editor = globals.Editor, Markdown;

  Markdown = function Markdown(editor) {
    this.editor = editor;
    this.refreshes = 0;
    this._shift = false;

    this.editor.events.textarea.keyup.autoComplete = this.onKeyUp;
    this.editor.events.textarea.keydown.shiftCheck = this.onKeyDown;
  }

  Markdown.prototype.destruct = function destruct() {
    delete this.editor.events.textarea.keydown.shiftCheck;
    delete this.editor.events.textarea.keyup.autoComplete;
    this.editor.elements.preview.html("");
  }

  Markdown.prototype.refresh = function refresh() {
    var self = this;

    self.editor.elements.preview.addClass("js-editor-rendering");
    $.ajax("/api/v1/format.json", {
      method: "POST",
      data: {
        format: "markdown",
        body: this.editor.elements.textarea.val()
      },
      success: function(body) {
        self.editor.elements.preview.html(body.body);
        self.editor.elements.preview.removeClass("js-editor-rendering");

        MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
      }
    });
  };

  Markdown.prototype.quote = function quote(text) {
    return text.replace(/(^|\n)/g, "\n> ");
  };

  Markdown.prototype.onKeyDown = function onKeyDown(event) {
    if(event.which === 16) {
      this.lang._shift = true;
    } else if(event.which === 9) {
      event.preventDefault();
    }
  };

  Markdown.prototype.onKeyUp = function onKeyUp(event) {
    var self = this.lang;
    if(event.which === 192) {
      // ` was pressed, insert another one.
      self._after('`');
    } else if(event.which === 56 && self._shift) {
      // * was pressed, insert another one.
      self._after('*');
    } else if(event.which === 57) {
      self._after(')');
    } else if(event.which === 219) {
      if(self._shift) {
        self._after('}');
      } else {
        self._after(']');
      }
    } else if(event.which === 189 && self._shift) {
      // _ was pressed, insert another one.
      self._after('_');
    } else if(event.which === 16) {
      // shift done being pressed.
      self._shift = false;
    } else if(event.which === 9) {
      self._before('  ');
    } else if(event.which === 8) {
      event.preventDefault();
      self._removeIndent();
    } else if(event.which === 13 && self._isOnEmptyLine()) {
      event.preventDefault();
      self._matchIndents();
    }
  };

  Markdown.prototype._after = function _after(insert) {
    this.editor.elements.textarea.insertAroundCursor('', insert);
  };

  Markdown.prototype._before = function _before(insert) {
    this.editor.elements.textarea.insertAroundCursor(insert, '');
  };

  Markdown.prototype._isOnEmptyLine = function _isOnEmptyLine() {
    var pos = this.editor.elements.textarea.cursorPosition(),
      lastNewline =
        this.editor.elements.textarea.val().lastIndexOf("\n", pos);

    console.log(pos, lastNewline);

    return Math.abs(pos - lastNewline) < 2;
  };

  Markdown.prototype._matchIndents = function _matchIndents() {
    var pos = this.editor.elements.textarea.cursorPosition(),
      val, lastNewLine, sub, match;

    val = this.editor.elements.textarea.val();
    lastNewLine = val.lastIndexOf("\n", pos - 2);

    sub = val.substring(lastNewLine, pos);
    match = sub.match(/^\n?([ \-\+\*\>]+).*/);
    console.log("MATCH", sub, match);
    if(match) {
      this._before(match[1]);
    }
  };

  Markdown.prototype._removeIndent = function  _removeIndent() {
    var pos, val, sub, lastNewline, match, i, e, l, r;

    pos = this.editor.elements.textarea.cursorPosition();
    val = this.editor.elements.textarea.val();
    lastNewline = val.lastIndexOf("\n", pos - 1);
    sub = val.substring(lastNewline, pos);
    match = sub.match(/^\n\s+$/);
    console.log("MATCH R", sub, match, pos, lastNewline);

    if(match) {
      l = val.substring(0, lastNewline + 1);
      r = val.substring(pos - (match[0].length - 2), val.length);

      this.editor.elements.textarea.val(l + r);

      this.editor.elements.textarea.selectRange(pos - 1);
    }
  };

  Editor.languages["markdown"] = Markdown;

})( window )
