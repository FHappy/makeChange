angular
  .module('makeChangeApp')
  .controller('FlashMessagesController', FlashMessagesController);

FlashMessagesController.$inject = ['$attrs'];

function FlashMessagesController($attrs) {
  const vm = this;

  vm.notice = $attrs.notice;
  vm.alert  = $attrs.alert;
}