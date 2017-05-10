HomePageController.$inject = ["UsersService"];

function HomePageController(UsersService) {
  const vm = this;

  vm.user = null;
  vm.charities = null;
  vm.currentUser = currentUser;
  vm.userHomeBackgroundImage = null;
  vm.image = null;

  function currentUser() {
  	UsersService
  		.getCurrentUser()
  		.then(function(res) {
  			vm.user = res.data.user;
        vm.charities = res.data.charities;
        vm.userHomeBackgroundImage = res.data.userHomeBackgroundImage;
        vm.image = res.data.image;
        console.log(res.data.image);
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