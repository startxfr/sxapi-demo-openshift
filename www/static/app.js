

app = {
  config: {
    apiUrl: "http://api-test.apps.startx.fr/"
  },
  init: function () {
    $.ajax({method: "GET", url: "/info"})
    .always(function (response, status) {
      if (status === "success" && response.code === "ok") {
        console.log(response);
        appContainer
        $("#appContainer").text(response.data.server.hostname);
        $("#appRelease").html(response.data.service.version + " <span style='color:grey'>via " + response.data.server.hostname+"</span>");
      }
      else {
        console.error(response.data || response);
      }
    });
    app.api.init();
    app.sirenConvert.init();
    app.tvaConvert.init();
  },
  api: {
    info: null,
    init: function () {
      this.get("info", null, function (error, response) {
        if (error) {
          var message = "impossible de contacter l'API car " + (error.message || error);
          $(app.tools.alertBox("danger", message)).insertAfter("div.jumbotron");
          console.error(message);
        }
        else {
          app.api.info = response;
        $("#appSvContainer").text(app.api.info.server.hostname);
          $("#appSvRelease").html(app.api.info.service.version + " <span style='color:grey'>via " + app.api.info.server.hostname+"</span>");
          var message = "vous êtes connecté à l'API <b>" +
          app.api.info.service.name +
          "</b> servi depuis le container <b>" +
          app.api.info.server.hostname + "</b>";
          $(app.tools.alertBox("info", message)).insertAfter("div.jumbotron");
        }
      });
    },
    get: function (path, query, callback) {
      return this.call("GET", path, query, callback);
    },
    post: function (path, query, callback) {
      return this.call("POST", path, query, callback);
    },
    put: function (path, query, callback) {
      return this.call("PUT", path, query, callback);
    },
    delete: function (path, query, callback) {
      return this.call("DELETE", path, query, callback);
    },
    call: function (method, path, query, callback) {
      var config = {
        method: method,
        url: app.config.apiUrl + path
      };
      if (query && query !== null && query !== false) {
        config.data = query;
      }
      $.ajax(config)
      .always(function (response, status) {
        if (status === "success") {
          if (response.code === "ok") {
            callback(null, response.data);
          }
          else {
            callback(response);
          }
        }
        else {
          callback(response);
        }
      });
    }
  },
  sirenConvert: {
    inputEl: null,
    btnEl: null,
    msgOkEl: null,
    msgNokEl: null,
    init: function () {
      this.inputEl = $("#sirenConvertInputSiren");
      this.btnEl = $("#sirenConvertBtn");
      this.msgOkEl = $("#sirenConvertSucessMessage");
      this.msgNokEl = $("#sirenConvertErrorMessage");
      this.msgOkEl.removeClass("hidden").hide();
      this.msgNokEl.removeClass("hidden").hide();
      this.btnEl.click(this.onClickConvert);
    },
    onClickConvert: function () {
      var $this = app.sirenConvert;
      $this.msgOkEl.hide();
      $this.msgNokEl.hide();
      if ($this.inputEl.val().length === 0) {
        $this.msgNokEl.show();
      }
      else {
        app.api.get("insee/" + $this.inputEl.val() + "/tva", null, function (error, response) {
          console.error(error, response);
          if (error) {
            $this.msgNokEl.show();
            console.error(error);
          }
          else {
            console.log(response);
            $("b", $this.msgOkEl).text(response);
            $this.msgOkEl.show();
          }
        });
      }
    }
  },
  tvaConvert: {
    inputEl: null,
    btnEl: null,
    msgOkEl: null,
    msgNokEl: null,
    init: function () {
      this.inputEl = $("#tvaConvertInputTva");
      this.btnEl = $("#tvaConvertBtn");
      this.msgOkEl = $("#tvaConvertSucessMessage");
      this.msgNokEl = $("#tvaConvertErrorMessage");
      this.msgOkEl.removeClass("hidden").hide();
      this.msgNokEl.removeClass("hidden").hide();
      this.btnEl.click(this.onClickConvert);
    },
    onClickConvert: function () {
      var $this = app.tvaConvert;
      $this.msgOkEl.hide();
      $this.msgNokEl.hide();
      if ($this.inputEl.val().length === 0) {
        $this.msgNokEl.show();
      }
      else {
        app.api.get("insee/" + $this.inputEl.val() + "/siren", null, function (error, response) {
          console.error(error, response);
          if (error) {
            $this.msgNokEl.show();
            console.error(error);
          }
          else {
            console.log(response);
            $("b", $this.msgOkEl).text(response);
            $this.msgOkEl.show();
          }
        });
      }
    }
  },
  tools: {
    alertBox: function (type, message) {
      return '<div class="alert alert-' + type + ' alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + message + "</div>";
    }
  }
};


$(document).ready(app.init);
