/*global location: false, Generic: false, jQuery: false */
/*jslint maxlen: 80 */

// Client is a resource client, which follows the CRUD rules as well
// as uses rails' csrf protection and authlogic's single use token
// authentication.
(function (expose) {
  'use strict';

  var Client;

  Client = function (host, port, protocol) {
    if (host === undefined) {
      host = location.host;
    }
    if (port === undefined) {
      port = location.port;
    }
    if (protocol === undefined) {
      protocol = location.protocol;
    }

    this.url          = {};
    this.url.host     = host;
    this.url.protocol = protocol;
    this.userToken    = null;
  };

  // Builds the whole url, including protocol and host.
  Client.prototype.buildUrl = function (path, format) {
    var buf;
    if (format === undefined) {
      if (path.match(/\.json$/)) {
        format = false;
      } else {
        format = true;
      }
    }

    if (path.match(/^\//)) {
      path = path.replace(/^\//, "");
    }

    buf = [
      this.url.protocol,
      "//",
      this.url.host,
      '/',
      path
    ];

    if (format) {
      buf.push('.json');
    }

    return buf.join('');
  };

  // This expects a hash of resources.  It's basically used to build a
  // path to the resource without needing anything else.  Example
  // input:
  //
  //   {
  //     users: '/',
  //     boards: '/',
  //     threads: '/:boards',
  //     posts: '/:boards/:posts',
  //     messages: '/:users',
  //     tags: '/'
  //   }
  Client.prototype.mapResources = function (resources) {
    this.resources = resources;
  };

  // Creates a path based on a resourceType.  Requires mapResources
  // in order to work.
  Client.prototype.urlFor = function (resourceType, id) {
    var path, dependencies, dependency, i, shortName, buf = [];
    if (this.resources === undefined) {
      throw "mapResources should be called before urlFor!";
    }
    if (!Array.isArray(id)) {
      id = [id];
    }

    path = this.resources[resourceType];
    if (path === undefined) {
      throw "No resource named " + resourceType + " was found!";
    }
    if (path.match(/\:([\w]+)/g)) {
      dependencies = path.match(/\:([\w]+)/g);
      if (dependencies.length !== id.length &&
          dependencies.length + 1 !== id.length) {
        throw "The number of IDs does not match the number of dependencies!";
      }
    } else {
      dependencies = [];
    }

    for (i = 0; i < dependencies.length; i += 1) {
      dependency = dependencies[i];
      shortName = dependency.replace(/^\:/g, "");
      buf.push(shortName, id.shift());
    }

    console.log(resourceType, path, dependencies, id);

    buf.push(resourceType);
    if (id.length > 0) {
      buf.push(id[0]);
    }

    return buf.join('/');
  };

  // Get the index of a resource.  It tries to put the first argument
  // through urlFor, but if that fails, it goes directly as the url.
  Client.prototype.index = function (r, callback) {
    this._ajaxCall({
      url: this.buildUrl(this._toUrl(r))
    }, callback);
  };

  // This is really just a convienience method since buildUrl manages
  // multiple ids.
  Client.prototype.show = Client.prototype.index;

  // This creates a new resource.
  Client.prototype.create = function (r, data, callback) {
    this._ajaxCall({
      url: this.buildUrl(this._toUrl(r)),
      type: "POST",
      data: data
    }, callback);
  };

  Client.prototype.update = function (r, data, callback) {
    if (!data) {
      data = {};
    }
    data._method = "PUT";
    this._ajaxCall({
      url: this.buildUrl(this._toUrl(r)),
      type: "POST",
      data: data
    }, callback);
  };

  Client.prototype.destroy = function (r, data, callback) {
    if (!data) {
      data = {};
    }
    data._method = "DELETE";
    this._ajaxCall({
      url: this.buildUrl(this._toUrl(r)),
      type: "POST",
      data: data
    }, callback);
  };

  Client.prototype.getToken = function (username, password, callback, force) {
    if (this.userToken && !force) {
      callback({ token: this.userToken}, true);
      return;
    }

    var self = this;
    this.create('sessions', { session: {
      name: username,
      password: password
    } }, function (data, status) {
      if (status) {
        self._getTokenCallback.call(self, data);
      }
      callback.call(self, data, status);
    });
  };

  Client.prototype._getTokenCallback = function (data) {
    this.userToken = data.token;
  };

  Client.prototype._toUrl = function (r) {
    var url;
    try {
      url = this.urlFor(r.resource, r.ids);
    } catch (e) {
      console.warn(e);
      url = r.toString();
    }
    return url;
  };

  Client.prototype._ajaxCall = function (args, callback) {
    jQuery.ajax({
      url: args.url,
      data: this._addCsrfProtection(args.data || {}),
      dataType: "json",
      type: args.type || "GET",
      success: function (data) {
        callback(data, true);
      },
      failure: function (data) {
        callback(data, false);
      }
    });
  };

  Client.prototype._addCsrfProtection = function (data) {
    var csrf_token, csrf_param;
    csrf_token = jQuery("meta[name=csrf-token]").attr('content');
    csrf_param = jQuery("meta[name=csrf-param]").attr('content');
    data[csrf_param] = csrf_token;
    if (this.userToken) {
      data.session = this.userToken;
    }
    return data;
  };


  expose.Client = Client;

}(Generic.lib));
