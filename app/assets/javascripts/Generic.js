//= require_self
//= require_tree ./editor

/*global window: false, document: false */

var Generic = Generic || (function ($) {
  "use strict";

  var Utils   = {}, // Your Toolbox
    Ajax    = {}, // Your Ajax Wrapper
    Events  = {}, // Event-based Actions
    Routes  = {}, // Your Page Specific Logic
    App     = {}, // Your Global Logic and Initializer
    Public  = {}; // Your Public Functions

  Utils = {
    settings: {
      debug: true,
      meta: {
        controller: -1,
        action: -1,
        currentUser: 0,
        homeURL: -1
      },
      init: function () {

        Utils.settings.meta.controller = $('meta[name="controller"]').attr("content");
        Utils.settings.meta.action = $('meta[name="action"]').attr("content");

        Utils.settings.meta.currentUser = $('meta[name="userid"]').attr("content");
        Utils.settings.meta.homeURL = $('meta[name="url"]').attr("content");

      }
    },
    cache: {
      window: window,
      document: document
    },
    home_url: function (path) {
      if (typeof path === "undefined") {
        path = '';
      }
      return Utils.settings.meta.homeURL + path + '/';
    },
    log: function (what) {
      if (Utils.settings.debug) {
        console.log(what);
      }
    },
    route: function () {

      var controller = Utils.settings.meta.controller;
      var action = Utils.settings.meta.action;

      if (typeof Routes[controller] !== 'undefined') {
        if (typeof Routes[controller].init !== 'undefined') {

          Routes[controller].init.call();
        }

        if (typeof Routes[controller][action] !== 'undefined') {

          Routes[controller][action].call();
        }
      }

    },
    Editors: [],
    Taggers: []
  };
  var _log = Utils.log;

  Ajax = {

  };

  Events = {
    endpoints: {
      formatSelectorChange: function (event) {
        event.data.changeSyntax($(this).val());
      }
    }
  };

  Routes = {
    posts: {
      index: function () {
        var formatSelector, editor, format, tagInput, form;

        formatSelector = $("form.for_editor div.format_select select");
        editor         = $("form.for_editor textarea.editor");
        if (editor.length < 1) {
          return;
        }
        format = formatSelector.val();
        Utils.Editors.push(new Public.Lib.Editor(
          editor,
          format,
          {
            "iconContainer": editor.parent().children('.high_bar')
              .children('.icon_container'),
            "output": editor.parent().children('.output_wrapper')
          }
        ));

        formatSelector.on('change', editor, Events.endpoints.formatSelectorChange);

        if ($("input#tag_input").length > 0) {
          form = $("form.for_editor");
          tagInput = $("input#tag_input");
          Utils.Taggers.push(new Public.Lib.Tagger(tagInput, {
            "wrapper": tagInput.parent(),
            "form":    form
          }));
        }
      }
      //edit: Routes.posts.index,
      //"new": Routes.posts.index
    }
  };

  Routes.posts.edit = Routes.posts["new"] = Routes.posts.index;

  App = {
    logic: {},
    init: function () {

      Utils.settings.init();
      Utils.route();

    }
  };

  Public = {
    init: App.init,
    Lib: { Parsers: {} }
  };

  if (Utils.settings.debug) {
    Public.Utils  = Utils;
    Public.Routes = Routes;
    Public.Events = Events;
    Public.App    = App;
  }

  return Public;

}(window.jQuery));

window.jQuery(document).ready(Generic.init);
