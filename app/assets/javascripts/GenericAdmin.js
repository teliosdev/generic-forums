//= require_self
//= require client/client
//= require admin/grapher
//= require admin/scroll

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

    }
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
      grapherResize: function (event) {
        Utils.Grapher.element.height($(window).height() -
                             $("header").height() - 356);
        event.data.recompute();
      }
    }
  };

  Routes = {
    dashboard: {
      index: function () {
        var data = {
          numberOfElements: 24,
          elements: []
        }, $e = $("div.graph"), i;

        $e.children("span.data").each(function (_, e) {
          data.elements.push($(e).data('value'));
        });

        //for(i = 0; i < data.numberOfElements; i += 1) {
        //  data.elements.push(Math.round(Math.random() * 25));
       // }

        Utils.Grapher = new Public.Lib.Grapher($e, data);
        $(window).on('resize', Utils.Grapher, Events.endpoints.grapherResize);
        $(window).resize();
      },

      scroll: function () {
        Generic.Scroll.bindEvent();
      }
    }
  };

  App = {
    logic: {},
    init: function () {

      Ajax.init();
      Utils.settings.init();
      Utils.route();

    },
  };

  Public = {
    init: App.init,
    Lib: {}
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