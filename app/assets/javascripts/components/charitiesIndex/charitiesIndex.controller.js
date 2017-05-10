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
	vm.progressBarWidth = progressBarWidth;
	vm.backgroundImageOne = null;
	vm.backgroundImageTwo = null;
	vm.progressColor = progressColor;
	vm.disabledOrNot = disabledOrNot;

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

	function searchByName(page) {
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
			});
	}

	function searchByCategory(page) {
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
			});
	}

	function searchByLocation(page) {
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

	function disabledOrNot(buttonName) {
		if (buttonName === "previous" && vm.currentPage === 1) {
			return "disabled"
		}
		if (buttonName === "next" && vm.charities.length < 20) {
			return "disabled"
		}
	}


	activate();
}