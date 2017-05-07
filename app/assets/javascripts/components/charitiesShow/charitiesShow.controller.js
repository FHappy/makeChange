angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = ["$stateParams", "$http", "CharitiesService", "UsersService"];

function CharitiesShowController($stateParams, $http, CharitiesService, UsersService) {
	var vm = this;

	vm.charity = null;
	vm.charityExists = false;
	vm.donate = donate;
	vm.currentUser = null;
	vm.tokenAmount = 1;
	vm.incrementToken = incrementToken;
	vm.decrementToken = decrementToken;

	function activate() {
		UsersService
			.getCurrentUser()
			.then(function resolve(response) {
				vm.currentUser = response.data.user;
				CharitiesService
					.findOneCharity($stateParams.ein)
					.then(function(response) {
						vm.charity = response.data.charity;
						console.log(response.data);
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

	function incrementToken() {
		var userTokens = vm.currentUser.token_amount;
		if (vm.charityExists) {
			var charityTokensLeft = 10 - vm.charity.token_amount;
		} else {
			var charityTokensLeft = 10 - vm.tokenAmount;
		}
		if (userTokens > vm.tokenAmount && charityTokensLeft >= vm.tokenAmount) {
			vm.tokenAmount++;
		}
	}

	function decrementToken() {
		var userTokens = vm.currentUser.token_amount;
		if (vm.tokenAmount > 1) {
			vm.tokenAmount--;
		}
	}
}