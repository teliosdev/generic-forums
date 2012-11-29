/*global location: false, Generic: false, jQuery: false */
/*jslint maxlen: 80 */
(function (expose, global) {
  'use strict';

  var Editor, FormatRegister, IFormatRegister, Tools, ITools;

  //-------------------------------------------------------
  // EDITOR
  //-------------------------------------------------------

  Editor = function (element, syntaxType, options) {
    this.element = element;
    this.syntaxType = syntaxType;
    this.options = options || {};
    this.hadPreviousSyntax = false;
    this.info = { ctrlPressed: false };
    this._wrapElement();
    this.changeSyntax(syntaxType);
    this.element.autosize({ append: "\n" });
  };

  Editor.prototype.changeSyntax = function (to, options) {
    var syntax;
    if (options === undefined) {
      options = this.options;
    }
    this._handleOptions(options);

    syntax = FormatRegister.findFormat(to);

    if (!syntax) {
      return;
    }
    if (this.hadPreviousSyntax) {
      this._cleanSyntax();
    }

    this.syntax = syntax;
    this.syntaxType = to;
    this.hadPreviousSyntax = true;

    this._addIcons(options);
    this._bindEvents();
    this._addOutputView(options);
    this.updateOutput();
    if (syntax.afterConstructorCallback !== undefined) {
      syntax.afterConstructorCallback(this);
    }
    return;
  };

  Editor.prototype.updateOutput = function () {
    var text;
    if (!this.syntax.supportsPreview) {
      return;
    }
    text = this.render(this.element.val());
    if (text.length === 0) {
      text = "<p class='gray'>nothing yet...</p>";
    }
    this.output.html(text);
  };

  /*
   * Will always output something.  If the current syntax doesn't
   * support a preview, it will output the text html escaped.
  */
  Editor.prototype.render = function (text) {
    var result;
    if (!this.syntax.supportsPreview) {
      result = Tools.escapeHTML(text);
    } else {
      result = this.syntax.render(text);
    }
    return result;
  };

  Editor.prototype._handleOptions = function (options) {
    if (options.iconContainer !== null) {
      this.iconContainer = options.iconContainer;
    }
    if (options.output !== null) {
      this.output = options.output;
    }
  };

  Editor.prototype._wrapElement = function () {
    if (!this.element.parent().hasClass('editor_wrapper')) {
      this.element.wrap('<div class="editor_wrapper" />');
    }
    this.wrapper = this.element.parent('.editor_wrapper');
  };

  Editor.prototype._addIcons = function (options) {
    var name, contents, buf;
    if (this.syntax.iconList === null) {
      return;
    }

    if (!options.iconContainer) {
      if (this.wrapper.children('.icon_container').length > 0) {
        this.wrapper.prepend("<div class='icon_container'></div>");
      }
      this.iconContainer = this.wrapper.children('.icon_container');
    }

    for (name in this.syntax.iconList) {
      if (this.syntax.iconList.hasOwnProperty(name)) {
        contents = this.syntax.iconList[name];
        buf = jQuery('<a></a>');
        buf.addClass('icon');
        buf.attr('data-name', name);
        buf.attr('title', name.replace(/\_/g, " "));
        buf.html(contents);
        this.iconContainer.append(buf);
      }
    }
  };

  Editor.prototype._addOutputView = function (options) {
    if (this.syntax.supportsPreview) {
      if (options.output || this.hadPreviousSyntax) {
        this.output.text("");
        this.output.show();
      } else {
        if (this.wrapper.children('.output_wrapper').length > 0) {
          this.wrapper.append('<div class="output_wrapper"></div>');
        }
        this.wrapper.children('.output_wrapper')
          .append('<div class="editor_output"></div>');
        this.output = this.wrapper.children('.output_wrapper')
          .children('.editor_output');
      }

    }
  };

  Editor.prototype._cleanSyntax = function () {
    this.wrapper.children(".output_wrapper").hide();
    this.iconContainer.children('a').remove();
  };

  Editor.prototype._findAndCall = function (key, from, scope, args) {
    var i, v;
    if (!(key instanceof Array)) {
      key = [key];
    }

    for (i = 0; i < key.length; i += 1) {
      v = key[i];
      if (from[v]) {
        from[v].apply(scope, args);
      }
    }
  };

  Editor.prototype._bindEvents = function () {
    this.iconContainer.children('a').on('click', this, function (event) {
      event.data.iconCallback(jQuery(this), event);
    });
    this.element.on('keyup', this, this.keyUpCallback);
    this.wrapper.on('keydown', this, this.keyDownCallback);
  };

  Editor.prototype.iconCallback = function (icon, event) {
    var n = icon.data('name');
    this._findAndCall(
      [n, 'any'],
      this.syntax.eventHandlers.iconPress,
      this.syntax,
      [this, icon, event]
    );
    this._findAndCall(
      [n, 'any'],
      this.eventHandlers.iconPress,
      this,
      [this, icon, event]
    );
  };

  Editor.prototype.keyUpCallback = function (event) {
    event.data._keyCallback('keyUp', event);
  };

  Editor.prototype.keyDownCallback = function (event) {
    event.data._keyCallback('keyDown', event);
  };

  Editor.prototype._keyCallback = function (type, event) {
    this._findAndCall(
      [event.which, 'any'],
      this.syntax.eventHandlers[type],
      this.syntax,
      [this, event]
    );
    this._findAndCall(
      [event.which, 'any'],
      this.eventHandlers[type],
      this,
      [this, event]
    );
  };

  Editor.prototype.eventHandlers = {
    keyUp: {
      17: function (m) {
        m.info.ctrlPressed = false;
      },
      any: function (m) {
        m.updateOutput();
      }
    },
    keyDown: {
      17: function (m) {
        m.info.ctrlPressed = true;
      }
    },
    iconPress: {
      any: function (m) {
        m.updateOutput();
      }
    }
  };

  Editor.VERSION = "3.0.0";
  expose.Editor = Editor;

  //-------------------------------------------------------
  // FORMAT REGISTER
  //-------------------------------------------------------

  IFormatRegister = function () {
    this.formats = {};
  };

  IFormatRegister.prototype.addFormat = function (format, syntax) {
    this.formats[format] = syntax;
  };

  IFormatRegister.prototype.removeFormat = function (format) {
    delete this.formats[format];
  };

  IFormatRegister.prototype.findFormat = function (format) {
    if (!this.formats[format]) {
      return null;
    }
    return new this.formats[format]();
  };

  expose.FormatRegister = FormatRegister = new IFormatRegister();

  //-------------------------------------------------------
  // TOOLS
  //-------------------------------------------------------
  ITools = function () {
  };

  ITools.prototype.escapeHTML = function (text) {
    var tag, i;
    for (i = 0; i < this._htmlEntities.length; i += 1) {
      tag = this._htmlEntities[i];
      text = text.replace(tag[0], tag[1]);
    }
    return text;
  };

  ITools.prototype._htmlEntities = [
    [/&/g, "&amp;" ],
    [/>/g, "&gt;"  ],
    [/</g, "&lt;"  ],
    [/"/g, "&quot;"], // "
    [/'/g, "&#39;" ], // '
  ];

  Tools = new ITools();

}(Generic.Lib, Generic));
