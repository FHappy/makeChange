angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = ["$stateParams", "$http", "CharitiesService", "UsersService", "CommentsService"];

function CharitiesShowController($stateParams, $http, CharitiesService, UsersService, CommentsService) {
	var vm = this;

	vm.charity = null;
	vm.donate = donate;
	vm.currentUser = null;
	vm.tokenAmount = 1;
	vm.incrementToken = incrementToken;
	vm.decrementToken = decrementToken;
	vm.newComment = {};
	vm.comments = null;
	vm.createComment = createComment;
	vm.deleteComment = deleteComment;
	vm.editedComment = null;
	vm.editComment = editComment;
	vm.updateComment = updateComment;

	function activate() {
		getCurrentUser();
		getCharity();
	}

	activate();

	function donate(ein, token) {
		CharitiesService.donate(ein, token)
			.then(function resolve(response) {
				vm.tokenAmount = 1;
				getCurrentUser();
				getCharity();
			}, function reject(response) {

			});
	}

	function incrementToken() {
		var userTokens = vm.currentUser.token_amount;
		if (vm.charity.created_at) {
			var charityTokensLeft = 10 - vm.charity.token_amount;
		} else {
			var charityTokensLeft = 10 - vm.tokenAmount;
		}
		if (userTokens > vm.tokenAmount && charityTokensLeft >= vm.tokenAmount) {
			vm.tokenAmount++;
		}
	}

	function decrementToken() {
		var userTokens = vm.currentUser.token_amount;
		if (vm.tokenAmount > 1) {
			vm.tokenAmount--;
		}
	}

	function getCurrentUser() {
		UsersService
			.getCurrentUser()
			.then(function resolve(response) {
				vm.currentUser = response.data.user;
			});
	}

	function getCharity() {
		CharitiesService
			.findOneCharity($stateParams.ein)
			.then(function(response) {
				vm.charity = response.data.charity;
				vm.comments = response.data.comments;
			});
	}

	function createComment() {
		CommentsService
			.createComment({
				charity_id: vm.charity.id,
				user_id: vm.currentUser.id,
				title: vm.newComment.title,
				content: vm.newComment.content
			})
			.then(function(response) {
				vm.newComment = {};
				activate();
			});
	}

	function deleteComment(commentId) {
		CommentsService
			.deleteComment(commentId)
			.then(function(response) {
				activate();
			});
	}

	function editComment(comment) {
		vm.editedComment = comment;
	}

	function updateComment() {
		CommentsService
			.updateComment(vm.editedComment)
			.then(function(response) {
				vm.editedComment = null;
				activate();
			})
	}
}