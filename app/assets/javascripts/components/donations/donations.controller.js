angular
  .module("makeChangeApp")
  .controller("DonationsController", DonationsController);

DonationsController.$inject = ['CharitiesService', 'UsersService', 'ActionCableChannel'];

function DonationsController(CharitiesService, UsersService, ActionCableChannel) {
  	var vm = this;
  	vm.donate = donate;
  	vm.tokenAmount = 1;
  	vm.currentUser = null;
  	vm.incrementToken = incrementToken;
  	vm.decrementToken = decrementToken;
  	vm.getTokenAmount = getTokenAmount;

  	function activate() {
    	getCurrentUser();
  	}

	activate();
	var consumer = new ActionCableChannel("DonationsChannel");
	var callback = function(response) {
		getCharity(vm.charity.ein);
		getCurrentUser();
	};
	consumer.subscribe(callback)
		.then(function() {
			console.log('donation made?');
		});

  	function donate(ein, token) {
		CharitiesService.donate(ein, token)
			.then(function resolve(response) {
				vm.tokenAmount = 1;
				getCurrentUser();
				getCharity(ein);
			}, function reject(response) {

			});
	}

	function getTokenAmount(charityTokenAmount) {
		array = [1,2,3,4,5,6,7,8,9,10];
		for (var i = 0; i < charityTokenAmount; i++){
			array.pop();
		}
		return array
	}

  	function incrementToken(charity) {
		var userTokens = vm.currentUser.token_amount;
		if (charity.created_at) {
			var charityTokensLeft = 10 - charity.token_amount;
		} else {
			var charityTokensLeft = 10 - vm.tokenAmount;
		}
		if (userTokens > vm.tokenAmount && charityTokensLeft > vm.tokenAmount) {
			vm.tokenAmount++;
		}
	}

	function decrementToken() {
		var userTokens = vm.currentUser.token_amount;
		if (vm.tokenAmount > 1) {
			vm.tokenAmount--;
		}
	}

  	function getCurrentUser() {
		UsersService
			.getCurrentUser()
			.then(function resolve(response) {
				vm.currentUser = response.data.user;
			});
	}

	function getCharity(ein) {
		CharitiesService
			.findOneCharity(ein)
			.then(function(response) {
				vm.charity = response.data.charity;
			});
	}
}