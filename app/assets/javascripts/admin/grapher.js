/*global window: false, $: false */

(function (expose, global) {
  'use strict';

  var Grapher;

  Grapher = function (element, data) {
    this.element = element;
    this.data    = this.normalizeData(data);
  };

  Grapher.prototype.normalizeData = function (data) {
    if (!data.elements) { throw "No data to graph!"; }
    if (!data.numberOfElements) {
      data.numberOfElements = data.elements.length;
    }
    if (!data.barPadding) {
      data.barPadding = 1;
    }
    if (!data.hasOwnProperty("showValues")) {
      data.showValues = true;
    }
    if (!data.barClass) {
      data.barClass = "graph-bar";
    }
    if (!data.maxValue) {
      data.maxValue = this.findMax(data.elements);
    }
    return data;
  };

  Grapher.prototype.recompute = function () {
    console.log("RECOMPUTING");
    this.data.elementWidth = this.element.width();
    this.data.barSize = Math.floor(this.data.elementWidth /
      (this.data.numberOfElements)) - 1;
    this.element.children('.' + this.data.barClass).remove();
    this.graph();
  };

  Grapher.prototype.graph = function () {
    var i, element, percent, elementHeight = this.element.height(), newBar;
    for (i = 0; i < this.data.numberOfElements; i += 1) {
      element = this.data.elements[i] || 0;
      if (typeof element === "number") {
        percent = element / this.data.maxValue;
        newBar  = $("<div/>");
        newBar.addClass(this.data.barClass);
        newBar.width(this.data.barSize);
        console.log(elementHeight * percent);
        newBar.height(elementHeight * percent);
        if (this.data.showValues) {
          newBar.text(element);
        }
        console.log("APPENDING TO ELEMENT", newBar);
        this.element.append(newBar);
      }
    }
  };

  Grapher.prototype.offset = function (number) {
    if (number > this.data.elements.length) {
      return null;
    }

    return this.data.elements[this.data.elements.length - 1 - number];
  };

  Grapher.prototype.findMax = function (elements) {
    var i, max = -Infinity;
    for (i = 0; i < elements.length; i += 1) {
      if (elements[i] > max) {
        max = elements[i];
      }
    }

    return max;
  };

  expose.Grapher = Grapher;

}(window.Generic.Lib, window));
