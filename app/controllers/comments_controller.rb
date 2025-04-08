class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy show]
  def index
    @comments = Comment.order(created_at: :desc)
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("new_comment", partial: "comments/form", locals: {comment: Comment.new})
          ]
        end
        format.html { head :no_content }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("new_comment", partial: "comments/form", locals: {comment: @comment})
          ]
        end
      end
    end
  end

  def show; end

  def edit; end

  def destroy
    @comment.destroy
    head :no_content
  end

  def update
    if @comment.update(comment_params)
      head :no_content
    else
      render :edit
    end
  end

  private

  def comment_params
    params.expect(comment: %i[content author])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
