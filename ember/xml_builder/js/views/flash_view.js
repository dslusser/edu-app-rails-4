var FlashView = Ember.View.extend({
  contentBinding: "App.FlashController.content",
  classNameBindings: ["notice", "alert", "error"],
  noticeBinding: "content.notice",
  alertBinding: "content.alert",
  errorBinding: "content.error",

  didInsertElement: function() {
    this.$("#message").hide();
    return App.FlashController.set("view", this);
  },

  show: function(callback) {
    return this.$("#message").css({
      top: "-40px"
    }).animate({
      top: "+=40",
      opacity: "toggle"
    }, 500, callback);
  },

  hide: function(callback) {
    return this.$("#message").css({
      top: "0px"
    }).animate({
      top: "-39px",
      opacity: "toggle"
    }, 500, callback);
  }
});

module.exports = FlashView;

