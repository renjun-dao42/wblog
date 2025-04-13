class HomeController < ApplicationController
  def index
    @newest = Post.includes(:labels, :likes).order(created_at: :desc).first
    @recent = Post.includes(:labels).order(created_at: :desc).offset(1).limit(3)
    @popular_posts = Post.includes(:labels).order(visited_count: :desc).limit(5)
    @labels = Label.includes(:posts).order(created_at: :desc).limit(20)
    @featured_labels = Label.joins(:posts)
                            .select('labels.*, COUNT(posts.id) as posts_count')
                            .group('labels.id')
                            .order('posts_count DESC')
                            .limit(10)
  end

  def about
  end
  
  def tag
    @label = Label.find_by(name: params[:name])
    if @label
      @posts = Post.includes(:labels, :likes)
                   .joins(:labels)
                   .where(labels: { id: @label.id })
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)
      @label_name = @label.name
    else
      redirect_to root_path, notice: t('archive.not_found')
    end
  end
end