(function( globals ) {

  "use strict";

  var Editor, defaultOptions;

  defaultOptions = {
    element: $("<div/>"),
    refreshDelay: 500
  };

  Editor = function Editor(options) {
    this.options  = $.extend({}, defaultOptions, options);
    this.element  = options.element;
    this.elements = {
      textarea: this.element.find('textarea'),
      format: this.element.find('select'),
      reply: this.element.find('.reply-body')
    };

    this.elements.textarea.autosize();
    this.setEvents();
    this.setupView();
  };

  Editor.languages = {};

  Editor.prototype.setupView = function setupView() {
    var preview;

    preview = $("<div/>");
    preview.addClass("js-preview");
    this.elements.preview = preview;
    this.elements.textarea.after(preview);

    this.elements.textarea.addClass("js-editor");
    this.setLanguage("markdown");
  };

  Editor.prototype.refreshPreview = function refreshPreview() {
    if(this.lang && this.lang.refresh) {
      this.lang.refresh();
    }
  }

  Editor.prototype.setLanguage = function setLanguage(newLanguage) {
    var lang, content, quote;

    this.language = newLanguage;

    lang = Editor.languages[this.language];
    if(this.lang && this.lang.destruct) {
      this.lang.destruct();
    }

    if(lang) {
      this.lang = new lang(this);
    } else {
      this.lang = null;
    }

    if(this.elements.reply.length == 1 && this.lang
      && this.lang.quote) {

      content = this.elements.textarea.val();
      quote = this.lang.quote(this.elements.reply.text());

      if(content.indexOf(quote) == -1) {
        content = [this.lang.quote(this.elements.reply.text()), "\n\n",
          content].join('');

        this.elements.textarea.val(content);
        this.elements.textarea.trigger('autosize.resize');
        this.elements.textarea.selectRange(content.length, content.length);
      }
    }

    this.elements.textarea.focus();
    this.refreshPreview();
  };

  Editor.prototype.setEvents = function setEvents() {
    var self = this, timeout = null, registerEvents;

    registerEvents = {
      textarea: ['keyup', 'keydown'],
      format: ['change']
    };

    this.events = {};

    $.each(registerEvents, function(key, value) {
      self.events[key] = {};

      $.each(value, function(_, type) {
        self.events[key][type] = {};
        self.elements[key].off(type);
        self.elements[key].on(type, function(event) {
          $.each(self.events[key][type], function(_, func) {
            func.call(self, event, key, type);
          });
        });
      });
    });

    this.events.textarea.keyup.refresh = function() {
      if(timeout) {
        clearTimeout(timeout);
      }

      timeout = setTimeout(function() {
        self.refreshPreview();
        timeout = null;
      }, self.options.refreshDelay);
    };

    this.events.format.change.changeLanguage = function() {
      this.setLanguage(this.elements.format.val());
    };
  };

  globals.Editor = Editor;

})( window )
