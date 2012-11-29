// This one was customized way byond the original...

jQuery.fn.extend({
  getSelection: function (n) {
    if (n == null)
      n = 0;

    return this.map(function (i) {
      if (document.selection) {
        this.focus();
        var sel = document.selection.createRange();
        return sel.text;
      }
      else if (this.selectionStart || this.selectionStart == '0') {
        return this.value.substring(this.selectionStart, this.selectionEnd);
      } else {
        return this.value;
      }
    })[n]
  },

  getPosition: function (n) {
    if(n == null)
      n = 0;

    return this.map(function (i) {
      if (document.selection) {
        this.focus();
        var sel = document.selection.createRange();
        if ( r === null )
          return { start: 0, end: i.value.length, length: 0, text: "" }

        var re = i.createTextRange();
        var rc = re.duplicate();
        re.moveToBookmark(r.getBookmark());
        rc.setEndPoint('EndToStart', re);

        return { start: rc.text.length, end: rc.text.length + r.text.length, length: r.text.length, text: r.text };

      } else if (this.selectionStart || this.selectionStart == '0') {
        return { start: this.selectionStart, end: this.selectionEnd, length: this.selectionEnd - this.selectionStart, text: this.value.substring(this.selectionStart, this.selectionEnd) }
      } else {
        return { start: 0, end: this.value.length, length: this.value.length, text: this.value }
      }
    })[n]
  },

  setSelection: function (myValue) {
    return this.each(function (i) {
      if (document.selection) {
        //For browsers like Internet Explorer
        this.focus();
        var sel = document.selection.createRange();
        sel.text = myValue;
        this.focus();
      }
      else if (this.selectionStart || this.selectionStart == '0') {
        //For browsers like Firefox and Webkit based
        var startPos = this.selectionStart;
        var endPos = this.selectionEnd;
        var scrollTop = this.scrollTop;
        this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
        this.focus();
        this.selectionStart = startPos + myValue.length;
        this.selectionEnd = startPos + myValue.length;
        this.scrollTop = scrollTop;
      } else {
        this.value += myValue;
        this.focus();
      }
    })
  },

  setPosition: function (start, end) {
    return this.each(function () {
      if (this.setSelectionRange) {
        this.focus();
        this.setSelectionRange(start, end);
      } else if (this.createTextRange) {
        this.focus();
        var range = this.createTextRange();
        range.collapse(true);
        range.moveEnd('character', end);
        range.moveStart('character', start);
        range.select();
      }
    });
  }
});
