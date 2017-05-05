angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.all = [];

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function(res) {
				vm.all.push(res.data.local);
				vm.all.push(res.data.third_party);
				vm.all = [].concat.apply([], vm.all);
			});

	}

	activate();
}