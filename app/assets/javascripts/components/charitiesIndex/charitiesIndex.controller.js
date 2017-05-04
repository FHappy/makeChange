angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.all = null;

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function(res) {
				vm.all = res.data;
			});

	}

	activate();
}