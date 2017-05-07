angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = ["$stateParams", "$http", "CharitiesService", "UsersService"];

function CharitiesShowController($stateParams, $http, CharitiesService, UsersService) {
	var vm = this;

	vm.charity = null;
	vm.donate = donate;
	vm.currentUser = null;

	function activate() {
		UsersService
			.getCurrentUser()
			.then(function resolve(response) {
				vm.currentUser = response.data.user;
				CharitiesService
					.findOneCharity($stateParams.ein)
					.then(function(res) {
						vm.charity = res.data;
						console.log(res.data);
					});
			});
		
	}

	activate();

	function donate(ein, token) {
		CharitiesService.donate(ein, token)
			.then(function resolve(response) {

			}, function reject(response) {

			});
	}
}