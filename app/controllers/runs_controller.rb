class RunsController < ApplicationController

before_action :authenticate_user!
before_action :set_run, only: [:show, :edit, :update, :destroy]

  def index
    #ログインユーザーの記録のみ抽出
    @myrun = Run.where(user_id: current_user.id)
    #ソート用のインスタンス設定
    @q= @myrun.ransack(params[:q])
    @run = @q.result(distinct: true)
    set_map
  end

  def new
    @run = Run.new
  end

  def show
    set_map
    @comment = @run.comments.build
    @comments = @run.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def create
    @run = Run.new(run_params)
    @run.user_id=current_user.id
    @run.name=current_user.name
    set_calc
    if @run.save
      redirect_to runs_path,notice:"大会記録を保存しました"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @run.hour = params[:run][:hour]
    @run.minute = params[:run][:minute]
    @run.second = params[:run][:second]
    @run.kyori = params[:run][:kyori]
    set_calc
    if @run.update(run_params)
      redirect_to runs_path,notice:"大会記録を更新しました"
    else
      render 'edit'
    end
  end

  def destroy
    @run.destroy
    redirect_to runs_path,notice:"大会記録を削除しました"
  end

  private
  def run_params
   params.require(:run).permit(:year,:address,:addresshyoji,:kyori,:taikai,:hour,:minute,:second,:content,:avatar,:latitude,:longitude)
  end

  def set_run
    @run = Run.find(params[:id])
  end

  #GoogleMap表示のデータ
  def set_map
    @hash = Gmaps4rails.build_markers(@run) do |run, marker|
      marker.lat run.latitude
      marker.lng run.longitude
    end
  end

  def set_calc
    #時間、分、秒の設定がなければ「0」を設定
    if @run.hour.nil?
      @run.hour = 0
    end
    if @run.minute.nil?
      @run.minute = 0
    end
    if @run.second.nil?
      @run.second = 0
    end
    #ソート用に記録を秒へ変換
    @run.time = (@run.hour * 3600) + (@run.minute * 60) + (@run.second)
    #記録を表示用に変換
    if @run.hour == 0
      if @run.minute == 0
        @run.timehyoji = @run.second.to_s + '秒'
      else
        @run.timehyoji = @run.minute.to_s + '分' + @run.second.to_s + '秒'
      end
    else
      @run.timehyoji = @run.hour.to_s + '時間' + @run.minute.to_s + '分' + @run.second.to_s + '秒'
    end
    #距離を表示用に変換
    if @run.kyori == 21
      @run.kyorihyoji = 'ハーフ'
    elsif @run.kyori == 42
      @run.kyorihyoji = 'フル'
    else
      @run.kyorihyoji = @run.kyori.to_s + 'km'
    end
  end

end
