//= require_self
//= require_tree ./editor
//= require client/client

/*global window: false, document: false */

var Generic = Generic || (function ($) {
  "use strict";

  var Utils   = {}, // Your Toolbox
    Ajax    = {}, // Your Ajax Wrapper
    Events  = {}, // Event-based Actions
    Routes  = {}, // Your Page Specific Logic
    App     = {}, // Your Global Logic and Initializer
    Public  = {}, // Your Public Functions
    _log;

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

        Utils.settings.meta.controller = $('meta[name="controller"]')
          .attr("content");
        Utils.settings.meta.action = $('meta[name="action"]').attr("content");

        Utils.settings.meta.currentUser = $('meta[name="userid"]')
          .attr("content");
        Utils.settings.meta.homeURL = $('meta[name="url"]').attr("content");

      }
    },
    cache: {
      window: window,
      document: document
    },
    home_url: function (path) {
      if (path === undefined) {
        path = '';
      }
      return Utils.settings.meta.homeURL + path + '/';
    },
    log: function (what) {
      if (Utils.settings.debug) {
        window.console.log(what);
      }
    },
    route: function () {

      var controller = Utils.settings.meta.controller,
        action = Utils.settings.meta.action;

      if (Routes[controller] !== undefined) {
        if (Routes[controller].init !== undefined) {

          Routes[controller].init.call();
        }

        if (Routes[controller][action] !== undefined) {

          Routes[controller][action].call();
        }
      }

    },
    Editors: [],
    Taggers: []
  };

  _log = Utils.log;

  Ajax = {
    Client: null,
    init: function () {
      Ajax.Client = new Public.Lib.Client();
      Ajax.Client.mapResources(Ajax.resourceMap);
    },
    resourceMap: {
      boards: "/",
      threads: "/:boards",
      posts: "/:boards/:threads",
      users: "/",
      messages: "/:users",
      api: "/api"
    }
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
      edit: function () {
        var formatSelector, editor, format, tagInput, form, ieditor;

        formatSelector = $("form.for_editor div.format_select select");
        editor         = $("form.for_editor textarea.editor");
        if (editor.length < 1) {
          return;
        }
        format = formatSelector.val();
        ieditor = new Public.Lib.Editor(
          editor,
          format,
          {
            "iconContainer": editor.parent().children('.high_bar')
              .children('.icon_container'),
            "output": editor.parent().children('.output_wrapper'),
            "client": Ajax.Client
          }
        );
        Utils.Editors.push(ieditor);

        formatSelector.on('change',
          ieditor,
          Events.endpoints.formatSelectorChange);

        if ($("input#tag_input").length > 0) {
          form = $("form.for_editor");
          tagInput = $("input#tag_input");
          Utils.Taggers.push(new Public.Lib.Tagger(tagInput, {
            "wrapper": tagInput.parent(),
            "form":    form
          }));
        }
      },

      index: function () {
        Routes.posts.edit();
        if (Utils.Editors && Utils.Editors.length > 0) {
          Utils.Editors[0].bindReplyLinks();
        }
        if (window.hljs) {
          //window.hljs.initHighlighting();
          $("li.post pre code").each(function(_, e) {
            var $e = $(e), ret;
            if ($e.parent().hasClass("plain_text")) {
              return;
            }
            ret = window.hljs.highlightAuto(
              $e.text()
            );
            //if (ret.r >= 10) {
              $e.html(ret.value);
              $e.addClass(ret.language);
            //}
          });
        }
      }
      //edit: Routes.posts.index,
      //"new": Routes.posts.index
    }, ropes: {}
  };

  Routes.posts["new"] = Routes.ropes["new"] = Routes.posts.edit;

  App = {
    logic: {},
    init: function () {

      Ajax.init();
      Utils.settings.init();
      Utils.route();

    },

    test: function () {
      Ajax.Client.getToken("Ac1dL3ak", "pyong");
      Ajax.Client.apiRequest("whoami", function (d) {
        _log(d);
      });
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
    Public.Ajax   = Ajax;
  }

  return Public;

}(window.jQuery));

window.jQuery(document).ready(Generic.init);
