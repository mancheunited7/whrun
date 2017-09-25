class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(comment_params)
    @run = @comment.run
    @notification = @comment.notifications.build(user_id: @run.user.id )

    respond_to do |format|
      if @comment.save
        format.html { redirect_to run_path(@run), notice: 'コメントを投稿しました。' }
        format.js { render :index}
        unless @comment.run.user_id == current_user.id
          Pusher.trigger("user_#{@comment.run.user_id}_channel", 'comment_created', {
            message: 'あなたが投稿した記録にコメントが付きました'
          })
        end
        Pusher.trigger("user_#{@comment.run.user_id}_channel", 'notification_created', {
          unread_counts: Notification.where(user_id: @comment.run.user.id, read: false).count
        })
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @run = Run.find(params[:run_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to run_path(id: @comment.run_id), notice:"コメントを編集しました"
    else
      render "comments/edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js {render :index}
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:run_id, :content)
    end
end
