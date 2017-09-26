module RunsHelper

  def run_img(run)
    return image_tag(run.avatar, size:"600x350") if run.avatar.present?
  end

end
