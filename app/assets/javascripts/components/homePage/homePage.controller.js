HomePageController.$inject = [];

function HomePageController() {
  const vm = this;

  vm.message = "hey yall its angular";
}

angular
  .module('makeChangeApp')
  .controller('HomePageController', HomePageController);