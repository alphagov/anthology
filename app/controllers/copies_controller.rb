class CopiesController < ApplicationController

  def new
    @copy = parent.copies.build
  end

  def create
    @copy = parent.copies.build(params[:copy])

    if @copy.save
      flash[:notice] = "Copy #{@copy.book_reference} has been added to the library."
      redirect_to book_path(@copy.book)
    else
      render :action => :new
    end
  end

  def borrow
    if resource.borrow(current_user)
      flash[:notice] = "Copy #{resource.book_reference} is now on loan to you."
    end
  rescue Copy::NotAvailable => e
    flash[:alert] = "Copy #{resource.book_reference} is already on loan to #{resource.current_user.name}."
  ensure
    redirect_to book_path(resource.book)
  end

  def return
    if resource.return(current_user)
      flash[:notice] = "Copy #{resource.book_reference} has now been returned. Thanks!"
    end
  rescue Copy::NotOnLoan => e
    flash[:alert] = "Copy #{resource.book_reference} is not on loan."
  rescue Copy::NotLoanedByUser => e
    flash[:alert] = "Copy #{resource.book_reference} is not on loan to you, so you cannot return it."
  ensure
    redirect_to book_path(resource.book)
  end

  private
    def parent
      @book = Book.find(params[:book_id])
    end

    def resource
      @copy = Copy.find_by_book_reference(params[:id]) || not_found
    end

end
