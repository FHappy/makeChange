

angular
  .module("makeChangeApp")
  .controller("DonationsController", DonationsController);

DonationsController.$inject = ['CharitiesService', 'UsersService', 'ActionCableChannel', "$timeout", "$scope", "SweetAlert"];

function DonationsController(CharitiesService, UsersService, ActionCableChannel, $timeout, $scope, SweetAlert) {
  	var vm = this;
  	vm.donate = donate;
  	vm.tokenAmount = 1;
  	vm.currentUser = null;
  	vm.incrementToken = incrementToken;
  	vm.decrementToken = decrementToken;
  	vm.progressBarWidth = progressBarWidth;
  	vm.progressColor = progressColor;

	vm.$onInit = function() {
		getCurrentUser();
		if (vm.charity && vm.charity.time_started) {
			var end = new Date(vm.charity.time_started);
			end.setDate(end.getDate() + 3);
			$timeout(function() {
				$(`#time-left-${vm.charity.ein}`).countdown({until: end, onExpiry: refund, alwaysExpire: true, layout: '<span class="hide-on-small-only">Only {dn} {dl}, {hn} {hl}, {mn} {ml}, {sn} {sl} left!</span><span class="hide-on-med-and-up">Only {dn}:{hn}:{mn}:{sn} Left!</span>'});				
			}, 500);
		}
		else{
			vm.$onChanges = function(){
				if (vm.charity.time_started) {
					var end = new Date(vm.charity.time_started);
					end.setDate(end.getDate() + 3);
					$timeout(function() {
						$(`#time-left-${vm.charity.ein}`).countdown({until: end, onExpiry: refund, alwaysExpire: true, layout: '<span class="hide-on-small-only">Only {dn} {dl}, {hn} {hl}, {mn} {ml}, {sn} {sl} left!</span><span class="hide-on-med-and-up">Only {dn}:{hn}:{mn}:{sn} Left!</span>'});				
					}, 500);
				}
			}
		}
  	}
	var consumer = new ActionCableChannel("DonationsChannel");
	var callback = function(response) {
		getCharity(vm.charity.ein);
	};
	consumer.subscribe(callback)
		.then(function() {
		});

  	function donate(ein, token) {
		CharitiesService.donate(ein, token)
			.then(function resolve(response) {
				vm.tokenAmount = 1;
				getCharity(ein);
			});
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
				vm.$onInit();
			});
	}

	function refund() {
		CharitiesService
			.refund(vm.charity.ein)
			.then(function(response) {
				vm.charity = response.data.charity;
			});
	}

	function progressBarWidth(charityTokenAmount) {
		var width = (charityTokenAmount / 10) * 100;
		return { "width": `${width}%` }
	}

	function progressColor(charityTokenAmount) {
		if (charityTokenAmount < 5) {
			return `darken-${5 - charityTokenAmount}`;
		}
		else if (charityTokenAmount === 5) {
			return ``;
		}
		else if (charityTokenAmount > 5 && charityTokenAmount < 8) {
			return `lighten-${charityTokenAmount - 5}`;
		}
		else {
			return `accent-${11 - charityTokenAmount}`;
		}
	}
	
	$scope.$on("$destroy", function() {
		$(`#time-left-${vm.charity.ein}`).countdown("destroy");
	});
}