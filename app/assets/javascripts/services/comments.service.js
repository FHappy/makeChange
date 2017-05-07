angular
	.module("makeChangeApp")
	.service("CommentsService", CommentsService);

CommentsService.$inject = ["$http"];

function CommentsService($http) {
	var self = this;

	self.createComment = createComment;
	self.deleteComment = deleteComment;
	self.updateComment = updateComment;

	function createComment(comment) {
		return $http.post("/api/comments", comment);
	}

	function deleteComment(commentId) {
		return $http.delete(`/api/comments/${commentId}`);
	}

	function updateComment(comment) {
		return $http.patch(`/api/comments`, comment);
	}
}