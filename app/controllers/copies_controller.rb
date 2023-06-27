class CopiesController < ApplicationController
  def show
    @copy = resource
    @book = @copy.book
    @previous_loans = @copy.loans.history
  end

  def new
    @copy = parent.copies.build
  end

  def lookup
    @copy = Copy.find_by(id: params[:id])

    if @copy
      redirect_to copy_path(@copy)
    else
      flash[:alert] = "Copy #{params[:id]} couldn't be found."
      redirect_to root_path
    end
  end

  def create
    @copy = parent.copies.build

    if @copy.save
      flash[:notice] = "Copy #{@copy.id} has been added to the library."
      redirect_to book_path(@copy.book)
    else
      render action: :new
    end
  end

  def borrow
    if resource.borrow(current_user)
      flash[:notice] = "Copy #{resource.id} is now on loan to you."
    end
  rescue Copy::NotAvailable
    flash[:alert] = "Copy #{resource.id} is already on loan to #{resource.current_user.name}."
  ensure
    redirect_to copy_path(resource)
  end

  def return
    if resource.return(current_user)
      flash[:notice] = "Copy #{resource.id} has now been returned. Thanks!"
    end
  rescue Copy::NotOnLoan
    flash[:alert] = "Copy #{resource.id} is not on loan."
  ensure
    redirect_to copy_path(resource)
  end

  def set_missing
    resource.set_missing
    flash[:notice] = "Copy ##{resource.id} has been marked as missing"
    redirect_to copy_path(resource)
  end

  def unset_missing
    resource.unset_missing
    flash[:notice] = "Copy ##{resource.id} is no longer marked as missing"
    redirect_to copy_path(resource)
  end

private

  def parent
    @book = Book.find(params[:book_id])
  end

  def resource
    @copy = Copy.find_by(id: params[:id]) || not_found
  end
end
