angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = [];

function CharitiesShowController() {
	var vm = this;

	vm.message = "charity show page, dwag";
}