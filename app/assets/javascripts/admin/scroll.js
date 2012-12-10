/*global window: false, $: false */


(function (expose, global) {
  "use strict";
  expose.resizeScrollLists = function () {
    var windowHeight = $(window).height(),
      windowWidth  = $(window).width();
    if (!(windowWidth < 480 && expose.fixSmallScreen())) {
      expose.fixBigScreen();
      $("div.wrapper ul").each(function (i, e) {
        var $e = $(e),
          offset         = $("header").height() + 10 +
            $e.parent().children("h2").height(),
          contentHeight  = windowHeight - offset,
          childrenHeight = $e.children("li").length * 51,
          needsScroll    = childrenHeight > contentHeight;
        $e.removeClass("scroll");
        $e.css("height", contentHeight);
        console.log("estimated children height: " + childrenHeight + "px");
        if (needsScroll && windowWidth > 480) {
          $e.addClass("scroll");
        }
      });
    }
  };

  expose.fixSmallScreen = function () {
    $("div.wrapper ul").each(function (i, e) {
      var $e = $(e),
        $element = $("<select class=\"" + $e.attr('class') + "\"></select>");
      if ($e.hasClass("scroll-no-condense")) {
        return false;
      }

      $element.addClass("scroll-fixed");
      $e.children("li").each(function (u, o) {
        var $o = $(o),
          url = $(o).children('a').attr('href'),
          contents = $(o).children('a').text();
        $element.append("<option value=\"" + url + "\">" + contents
                        + "</option>");
      });

      $e.replaceWith($element);
    });
    $("div.wrapper select.scroll-fixed").on("change", function () {
      window.location.href = $(this).val();
    });

    $("html").addClass("scroll-screen-fixed");
    return true;
  };

  expose.fixBigScreen = function () {
    if (!$("html").hasClass("scroll-screen-fixed")) {
      return;
    }
    $("div.wrapper select.scroll-fixed").each(function (i, e) {
      var $e = $(e),
        $element = $("<ul class=\"" + $e.attr('class') + "\"></ul>");

      if ($e.hasClass("scroll-no-expand")) {
        return;
      }

      $element.removeClass("scroll-fixed");
      $element.append("<div class='top-gradient grid_3'></div>");
      $e.children("option").each(function (u, o) {
        var $o = $(o),
          url = $(o).attr('value'),
          contents = $(o).text();
        $element.append("<li><a href=\"" + url + "\">" + contents
                        + "</a></li>");
      });
      $element.append('<div class="bottom-gradient grid_3"></div>');
      $e.replaceWith($element);
    });

    expose.BindEvent();
  };

  expose.bindEvent = function () {
    $("div.wrapper ul").on("scroll", function (e) {
      var $e = $(e.currentTarget),
        scrollPos   = $e[0].scrollHeight - $e.scrollTop(),
        outerHeight = $e.outerHeight();
      if (scrollPos === outerHeight) {
        $e.children("div.bottom-gradient").hide();
      } else {
        $e.children("div.bottom-gradient").show();
      }

      if (scrollPos === $e[0].scrollHeight) {
        $e.children("div.top-gradient").hide();
      } else {
        $e.children("div.top-gradient").show();
      }
    });
    $("div.wrapper ul").scroll();
  };

}(window.Generic.Lib.Scroll = {}, window));
