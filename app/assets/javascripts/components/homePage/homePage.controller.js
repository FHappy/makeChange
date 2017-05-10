HomePageController.$inject = ["UsersService"];

function HomePageController(UsersService) {
  const vm = this;

  vm.user = null;
  vm.charities = null;
  vm.currentUser = currentUser;

  function currentUser() {
  	UsersService
  		.getCurrentUser()
  		.then(function(res) {
  			vm.user = res.data.user;
        vm.charities = res.data.charities;
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