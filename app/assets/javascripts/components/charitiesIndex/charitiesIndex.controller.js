angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.charities = [];
	vm.searchByName = searchByName;
	vm.suggested = null;
	vm.query = null;
	vm.categoryQuery = null;
	vm.locationQuery = null;
	vm.searchByCategory = searchByCategory;
	vm.searchByLocation = searchByLocation;

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function resolve(response) {
				vm.charities = response.data.charities;
			});
	}

	function searchByName() {
		CharitiesService
			.getNameQueries(vm.query)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
				vm.query = null;
			});
	}

	function searchByCategory() {
		CharitiesService
			.getCategoryQueries(vm.categoryQuery)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
			});
	}

	function searchByLocation() {
		CharitiesService
			.getLocationQueries(vm.locationQuery)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
				vm.locationQuery = null;
			});
	}


	activate();
}