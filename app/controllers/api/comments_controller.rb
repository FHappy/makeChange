class Api::CommentsController < ApplicationController
	def create
		comment = Comment.create(req_body)

		render json: comment
	end

	def destroy
		comment = Comment.find(params[:id]).destroy

		render json: comment
	end

	def update
		comment = Comment.update(params[:id], req_body)

		render json: comment
	end

	private

	def req_body
		params.require(:comment).permit(:user_id, :charity_id, :title, :content)
	end
end