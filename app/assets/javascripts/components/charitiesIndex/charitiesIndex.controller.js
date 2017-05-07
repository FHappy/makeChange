angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.charities = [];
	vm.searchByName = searchByName;
	vm.suggested = null;

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function resolve(response) {
				vm.charities = response.data.charities;

			});
	}

	function searchByName() {
		var query = $('.searchByName').val();
		console.log(query)
		CharitiesService
			.getNameQueries(query)
			.then(function(response) {
				vm.charities = response.data.charities
				vm.suggested = response.data.suggested
			});
	}


	activate();
}