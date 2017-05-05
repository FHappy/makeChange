FlashMessagesController.$inject = ['$scope', '$attrs', 'FlashMessage'];

function FlashMessagesController($scope, $attrs, FlashMessage) {
  const vm = this;
  vm.factory = FlashMessage;

  var initial = eval($attrs.initial);
  
  if (initial.length) {
    FlashMesage.setshow($attrs.initial[0][0]);
    FlashMesage.setmessage($attrs.intial[0][1]);
  }

}

angular
  .module('makeChangeApp')
  .controller('FlashMessagesController', FlashMessagesController);