angular
	.module("makeChangeApp")
	.service("CharitiesService", CharitiesService);

CharitiesService.$inject = ["$http"];

function CharitiesService() {
	const self = this;

	// self.all = getAllCharities

	// function getAllCharities() {
	// 	return $http.get("/api/charities");
	// }
}