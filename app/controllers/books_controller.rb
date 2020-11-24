class BooksController < ApplicationController

  protect_from_forgery except: :create # createアクションを除外
  def new
  end

  def create
    @book = Book.new(book_params)
    @book.title = book_params[:title]
    @book.body = book_params[:body]
    @book.user_id = current_user.id
    logger.debug('book save前')
    logger.debug(@book.title)
    logger.debug(@book.body)
    logger.debug(@book.user_id)
    if @book.save
      flash[:notice] = 'You have created book successfully.'
      redirect_to book_path(@book.id)
    else
      logger.debug('book save 失敗')
      flash[:notice] = 'create book error happen.'
      # flash[:book] = 'create book error happen.'
      @books = Book.all
    # @books = Book.joins(:users).select("books.*, users.*")
      u = []
      @books.each {|book|
        u.push(book.user_id)
      }
      us = User.where(id: u)
      @users = {}
      us.each {|u|
      # user = BookUser.new(user_id: u.id, user_name: u.name, image_id: u.profile_image)
      # @users[u.id] = user
      # @users[u.id] = {:name => u.name, :image_id => u.profile_image}
        @users[u.id] = u
      }
      render :index
      # redirect_to books_path
    end
  end

  def index
    logger.debug("books indexの中に入りました")
    @books = Book.all
    # @books = Book.joins(:users).select("books.*, users.*")
    u = []
    @books.each {|book|
      u.push(book.user_id)
    }
    us = User.where(id: u)
    @users = {}
    us.each {|u|
      # user = BookUser.new(user_id: u.id, user_name: u.name, image_id: u.profile_image)
      # @users[u.id] = user
      # @users[u.id] = {:name => u.name, :image_id => u.profile_image}
      @users[u.id] = u
    }
  end

  def show
    logger.debug("books showの中に入りました")
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @notice = flash[:notice]

    # redirect_to book_path(@book.id)
  end

  def edit
    @book = Book.find(params[:id])
    if current_user.id != @book.user_id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = 'You have updated book successfully.'
      # redirect_to user_path(@book.user_id)
      redirect_to book_path(@book.id)
    else
      logger.debug('book save 失敗')
      flash[:notice] = 'update book error happen.'
      # redirect_to user_path(@book.user_id)
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

# 投稿データのストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end
end
