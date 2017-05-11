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
	self.refund = refund;

	function getNameQueries(query, page) {
		return $http.get(`/api/charities/search/${query}/${page}`);
	}

	function getAllCharities() {
		return $http.get("/api/charities");
	}

	function findOneCharity(ein) {
		return $http.get(`/api/charities/${ein}`);
	}

	function getCategoryQueries(query, page) {
		return $http.get(`/api/charities/search_category/${query}/${page}`);
	}

	function donate(ein, token) {
		return $http.post('/api/charities', {token: token, ein: ein});
	}

	function getLocationQueries(query, page) {
		return $http.get(`/api/charities/search_location/${query}/${page}`);
	}

	function refund(ein) {
		return $http.get(`/api/charities/refund/${ein}`);
	}
}