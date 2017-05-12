angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService", "NgMap"];

function CharitiesIndexController(CharitiesService, NgMap) {
	var vm = this;

	vm.charities = [];
	vm.searchByName = searchByName;
	vm.suggested = null;
	vm.query = null;
	vm.nameQuery = null;
	vm.categoryQuery = null;
	vm.locationQuery = null;
	vm.searchByCategory = searchByCategory;
	vm.searchByLocation = searchByLocation;
	vm.image = null;
	vm.currentPage = 1;
	vm.nextPage = nextPage;
	vm.previousPage = previousPage;
	vm.currentSearch = null;
	vm.resetPage = resetPage;
	vm.currentQuery = null;
	vm.backgroundImageOne = null;
	vm.backgroundImageTwo = null;
	vm.disabledOrNot = disabledOrNot;
	vm.loading = false;
	vm.googleMapsUrl = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDqvhqBcDAJrmCiaSkp_6SfUET_rvDP2l8"
	vm.mapCenter = [37.09024, -95.712891];
	vm.showDetail = showDetail;
	vm.charityInfoWindow = null;
	vm.hideDetail = hideDetail;

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function resolve(response) {
				vm.charities = response.data.charities;
				vm.image = response.data.image;
				vm.backgroundImageOne = response.data.backgroundImageOne;
				vm.backgroundImageTwo = response.data.backgroundImageTwo;
			});
	}

	NgMap.getMap()
		.then(function(map) {
			vm.map = map;
		});

	function showDetail(e, charity) {
		vm.charityInfoWindow = charity;
		vm.map.showInfoWindow('charity-iw', charity.ein);
	}

	function hideDetail() {
		vm.map.hideInfoWindow('charity-iw');
	}

	function searchByName(page) {
		vm.loading = true;
		CharitiesService
			.getNameQueries(vm.currentQuery, page)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
				vm.currentSearch = 'Searching by name...';
				vm.query = null;
				vm.loading = false;
			});
	}

	function searchByCategory(page) {
		vm.loading = true;
		CharitiesService
			.getCategoryQueries(vm.currentQuery, page)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
				vm.currentSearch = 'Searching by category...';
				vm.loading = false;
			});
	}

	function searchByLocation(page) {
		vm.loading = true;
		CharitiesService
			.getLocationQueries(vm.currentQuery, page)
			.then(function(response) {
				vm.charities = response.data.charities;
				if (response.data.suggested.length > 0) {
					vm.suggested = response.data.suggested;
				}
				else {
					vm.suggested = null;
				}
				vm.locationQuery = null;
				vm.currentSearch = 'Searching by location...';
				vm.loading = false;
			});
	}

	function nextPage() {
		vm.currentPage++;
		changePage(vm.currentPage);
	}

	function previousPage() {
		vm.currentPage--;
		changePage(vm.currentPage);
	}

	function changePage(page) {
		switch (vm.currentSearch) {
			case 'Searching by name...':
				searchByName(page);
				break;
			
			case 'Searching by category...':
				searchByCategory(page);
				break;
			
			case 'Searching by location...':
				searchByLocation(page);
				break;
		}
	}

	function resetPage(query) {
		vm.currentQuery = query;
		vm.currentPage = 1;
	}

	function disabledOrNot(buttonName) {
		if (vm.loading === true) {
			return "disabled"
		}
		if (buttonName === "previous" && vm.currentPage === 1) {
			return "disabled"
		}
		if (buttonName === "next" && vm.charities.length < 20) {
			return "disabled"
		}
	}


	activate();
}