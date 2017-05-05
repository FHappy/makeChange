angular
	.module("makeChangeApp")
	.service("CharitiesService", CharitiesService);

CharitiesService.$inject = ["$http"];

function CharitiesService($http) {
	const self = this;

	self.getAllCharities = getAllCharities
	self.findOneCharity = findOneCharity

	function getAllCharities() {
		return $http.get("/api/charities");
	}

	function findOneCharity(ein) {
		return $http.get(`/api/charities/${ein}`);
	}
}