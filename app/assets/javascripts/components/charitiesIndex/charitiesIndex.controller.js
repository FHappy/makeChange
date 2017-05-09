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
	vm.image = null;

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function resolve(response) {
				vm.charities = response.data.charities;
				vm.image = response.data.image;
			});
	}

	function searchByName(page) {
		CharitiesService
			.getNameQueries(vm.query, page)
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

	function searchByCategory(page) {
		CharitiesService
			.getCategoryQueries(vm.categoryQuery, page)
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

	function searchByLocation(page) {
		CharitiesService
			.getLocationQueries(vm.locationQuery, page)
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