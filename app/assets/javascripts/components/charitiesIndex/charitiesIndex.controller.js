angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.all = [];
	vm.charities = [];

	function activate() {
		CharitiesService
			.indexQuery(1)
			.then(function resolve(response) {
				vm.charities = response.data.charities;
			});
	}

	activate();
}