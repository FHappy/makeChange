angular
	.module("makeChangeApp")
	.controller("CharitiesIndexController", CharitiesIndexController);


CharitiesIndexController.$inject = ["CharitiesService"];

function CharitiesIndexController(CharitiesService) {
	var vm = this;

	vm.all = [];
	vm.local = [];
	vm.thirdParty = [];

	function activate() {
		CharitiesService
			.getAllCharities()
			.then(function(res) {
				vm.local = res.data.local;
				vm.thirdParty = res.data.third_party;
				vm.all.push(vm.local);
				vm.all.push(vm.thirdParty);
				vm.all = [].concat.apply([], vm.all);
			});

	}

	activate();
}