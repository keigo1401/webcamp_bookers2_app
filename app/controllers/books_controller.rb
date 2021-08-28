class BooksController < ApplicationController
     before_action :authenticate_user!
     before_action :ensure_current_user, {only: [:edit,:update,:destroy]}
     #(ログインユーザー以外の人が情報を遷移しようとした時に制限をかける)


  def new
    @book = Book.new
  end

  def create
    @user = current_user
    @book = Book.new(book_params)
    @book.user_id = (current_user.id)
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      flash[:notice] = "errors prohibited this obj from being saved:"
      render "index"
    end
  end

  def index
    @user = current_user
    @books = Book.all
    @book = Book.new
    @book.user_id = current_user.id
  end

  def show
    @books = Book.find(params[:id])
    @user = @books.user
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      flash[:notice] = 'errors prohibited this obj from being saved:'
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end


  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_current_user
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end

end