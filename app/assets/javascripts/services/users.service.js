angular
	.module("makeChangeApp")
	.service("UsersService", UsersService);

UsersService.$inject = ["$http"];

function UsersService($http) {
	const self = this;

	self.getCurrentUser = getCurrentUser;

	function getCurrentUser() {
		return $http.get("/api/users/current");
	}
}