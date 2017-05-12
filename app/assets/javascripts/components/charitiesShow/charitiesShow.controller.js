angular
	.module("makeChangeApp")
	.controller("CharitiesShowController", CharitiesShowController);

CharitiesShowController.$inject = ["$stateParams", "CharitiesService", "UsersService", "CommentsService", "ActionCableChannel", "NgMap"];

function CharitiesShowController($stateParams, CharitiesService, UsersService, CommentsService, ActionCableChannel, NgMap) {
	var vm = this;

	vm.charity = null;
	vm.currentUser = null;
	vm.newComment = {};
	vm.comments = null;
	vm.createComment = createComment;
	vm.deleteComment = deleteComment;
	vm.editedComment = null;
	vm.editComment = editComment;
	vm.updateComment = updateComment; 	
	vm.image = null;
	vm.googleMapsUrl = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDqvhqBcDAJrmCiaSkp_6SfUET_rvDP2l8"

	function activate() {
		getCurrentUser();
		getCharity();
	}

	activate();

	var consumer = new ActionCableChannel("CommentsChannel");
	var callback = function(response) {
		vm.comments.push(response.comment);
	};

	consumer.subscribe(callback)
		.then(function() {
			console.log('it worked!');
		});

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
				vm.image = response.data.image[vm.charity.category]; 
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
				activate();
				vm.newComment = {};
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