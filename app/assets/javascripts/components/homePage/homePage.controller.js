HomePageController.$inject = ["UsersService"];

function HomePageController(UsersService) {
  const vm = this;

  vm.user = null;

  function currentUser() {
  	UsersService
  		.getCurrentUser()
  		.then(function(res) {
  			vm.user = res.data;
  		});
  }

  function activate() {
  	currentUser();
  }

  activate();
}

angular
  .module('makeChangeApp')
  .controller('HomePageController', HomePageController);