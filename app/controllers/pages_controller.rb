class PagesController < ApplicationController
  # GET /pages
  # GET /pages.json
  def index
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end
end
