angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = ["$stateParams", "$http", "CharitiesService"];

function CharitiesShowController($stateParams, $http, CharitiesService) {
	var vm = this;

	vm.charity = null;

	function activate() {
		CharitiesService
			.findOneCharity($stateParams.ein)
			.then(function(res) {
				vm.charity = res.data;
				console.log(res.data);
			});
	}

	activate();
}