angular
	.module("makeChangeApp")
	.service("CharitiesService", CharitiesService);

CharitiesService.$inject = ["$http"];

function CharitiesService($http) {
	const self = this;

	self.getAllCharities = getAllCharities;
	self.findOneCharity = findOneCharity;
	self.donate = donate;
	self.getNameQueries = getNameQueries;
	self.getCategoryQueries = getCategoryQueries;
	self.getLocationQueries = getLocationQueries;

	function getNameQueries(query) {
		return $http.get(`/api/charities/search/${query}`);
	}

	function getAllCharities() {
		return $http.get("/api/charities");
	}

	function findOneCharity(ein) {
		return $http.get(`/api/charities/${ein}`);
	}

	function getCategoryQueries(query) {
		return $http.get(`/api/charities/search_category/${query}`);
	}

	function donate(ein, token) {
		return $http.post('/api/charities', {token: token, ein: ein});
	}

	function getLocationQueries(query) {
		return $http.get(`/api/charities/search_location/${query}`);
	}
}