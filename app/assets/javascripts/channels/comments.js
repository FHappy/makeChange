//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.comments = App.cable.subscriptions.create('CommentsChannel', {
  received: function(data) {
    $("#comments").removeClass('hidden')
    return $('#comments').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.comment.title + ": </b>" + data.comment.content + "</p>";
  }
});