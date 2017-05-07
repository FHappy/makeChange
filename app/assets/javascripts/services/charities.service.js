angular
	.module("makeChangeApp")
	.service("CharitiesService", CharitiesService);

CharitiesService.$inject = ["$http"];

function CharitiesService($http) {
	const self = this;

	self.getAllCharities = getAllCharities;
	self.findOneCharity = findOneCharity;
	self.indexQuery = indexQuery;
	self.donate = donate;

	function getAllCharities() {
		return $http.get("/api/charities");
	}

	function findOneCharity(ein) {
		return $http.get(`/api/charities/${ein}`);
	}

	function indexQuery(page) {
		return $http.get(`/api/charities/index/${page}`);
	}

	function donate(ein, token) {
		return $http.post('/api/charities', {token: token, ein: ein});
	}
}