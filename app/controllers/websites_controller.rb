class WebsitesController < ApplicationController
  # GET /websites
  # GET /websites.json
  def index
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    
    @websites = Website.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @websites }
    end
  end

  # GET /websites/1
  # GET /websites/1.json
  def show
    if user_signed_in?
      @website = Website.find(params[:id])
      
      @top_pages = Page.find_by_sql("SELECT * FROM pages WHERE website_id = #{@website.id} ORDER BY (facebook+linkedin+gplus+twitter) DESC LIMIT 5")
      
      if @website.user_id == current_user.id
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @website }
        end
      else
        render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
    end
  end

  # GET /websites/new
  # GET /websites/new.json
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
  end

  # POST /websites
  # POST /websites.json
  def create
    if user_signed_in?
      @website = Website.new(params[:website])
      @website.user_id = current_user.id
      @website.frequency = 86400 # Per default we crawl once a day

      respond_to do |format|
        if @website.save
          format.html { redirect_to "/", notice: 'Website was successfully created.' }
          format.json { render json: @website, status: :created, location: @website }
        else
          format.html { render action: "new" }
          format.json { render json: @website.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.json
  def update
    if user_signed_in?
      @website = Website.find(params[:id])
      if @website.user_id == current_user.id
        respond_to do |format|
          if @website.update_attributes(params[:website])
            format.html { redirect_to "/", notice: 'Website was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @website.errors, status: :unprocessable_entity }
          end
        end
      else
        render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    if user_signed_in?
      @website = Website.find(params[:id])
      if @website.user_id == current_user.id
        @website.pages.each do |p|
          p.statistics.each do |s|
            s.destroy
          end
          p.destroy
        end
        @website.destroy

        respond_to do |format|
          format.html { redirect_to "/" }
          format.json { head :no_content }
        end
      else
        render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
    end
  end
  
  def reindex
    if user_signed_in?
      @website = Website.find(params[:id])
      if @website.user_id == current_user.id
        @website.pages.each do |p|
          p.statistics.each do |s|
            s.destroy
          end
          p.destroy
        end
        
        respond_to do |format|
          format.html { redirect_to "/", notice: 'Website is scheduled for reindexing.' }
          format.json { head :no_content }
        end
      else
        render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
    end
  end
end
