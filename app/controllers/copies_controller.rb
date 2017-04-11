class CopiesController < ApplicationController

  def show
    @copy = resource
    @book = @copy.book
    @previous_loans = @copy.loans.history
  end

  def new
    @copy = parent.copies.build
  end

  def edit
    @copy = Copy.find_by_book_reference(params[:id])
    @book = @copy.book
  end

  def lookup
    @copy = Copy.find_by_book_reference(params[:book_reference])

    if @copy
      redirect_to copy_path(@copy)
    else
      flash[:alert] = "Copy #{params[:book_reference]} couldn't be found."
      redirect_to root_path
    end
  end

  def create
    @copy = parent.copies.build(copy_params)

    if params[:copy_has_id_number].blank?
      @copy.book_reference = nil
    end

    if @copy.save
      flash[:notice] = "Copy #{@copy.book_reference} has been added to the library."
      redirect_to book_path(@copy.book)
    else
      render :action => :new
    end
  end

  def update
    @copy = Copy.find_by_book_reference(params[:id])
    if @copy.update_attributes(params.require(:copy).permit(:shelf_id))
      flash[:notice] = 'Shelf updated'
      redirect_to copy_path(@copy)
    else
      render :action => :edit
    end
  end

  def borrow
    if resource.borrow(current_user)
      flash[:notice] = "Copy #{resource.book_reference} is now on loan to you."
    end
  rescue Copy::NotAvailable => e
    flash[:alert] = "Copy #{resource.book_reference} is already on loan to #{resource.current_user.name}."
  ensure
    redirect_to copy_path(resource)
  end

  def return
    if resource.return(current_user, shelf)
      msg = "Copy #{resource.book_reference} has now been returned"
      if shelf
        msg << " to #{shelf}"
      end
      msg << ". Thanks!"
      flash[:notice] = msg
    end
  rescue Copy::NotOnLoan => e
    flash[:alert] = "Copy #{resource.book_reference} is not on loan."
  ensure
    redirect_to copy_path(resource)
  end

  def set_missing
    resource.set_missing
    flash[:notice] = "Copy ##{resource.book_reference} has been marked as missing"
    redirect_to copy_path(resource)
  end

  def unset_missing
    resource.unset_missing
    flash[:notice] = "Copy ##{resource.book_reference} is no longer marked as missing"
    redirect_to copy_path(resource)
  end

  private
    def shelf
      shelf_id = params.require(:copy).fetch(:shelf_id, nil)
      shelf_id && Shelf.find_by_id(shelf_id)
    end

    def parent
      @book = Book.find(params[:book_id])
    end

    def resource
      @copy = Copy.find_by_book_reference(params[:id]) || not_found
    end

    def copy_params
      params.require(:copy).permit(:book_id, :book_reference, :on_loan, :shelf_id)
    end
end
