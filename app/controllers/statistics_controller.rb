class StatisticsController < ApplicationController
  # GET /statistics
  # GET /statistics.json
  def index
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistics = Statistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statistics }
    end
  end

  # GET /statistics/1
  # GET /statistics/1.json
  def show
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @statistic }
    end
  end

  # GET /statistics/new
  # GET /statistics/new.json
  def new
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @statistic }
    end
  end

  # GET /statistics/1/edit
  def edit
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.find(params[:id])
  end

  # POST /statistics
  # POST /statistics.json
  def create
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.new(params[:statistic])

    respond_to do |format|
      if @statistic.save
        format.html { redirect_to @statistic, notice: 'Statistic was successfully created.' }
        format.json { render json: @statistic, status: :created, location: @statistic }
      else
        format.html { render action: "new" }
        format.json { render json: @statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statistics/1
  # PUT /statistics/1.json
  def update
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.find(params[:id])

    respond_to do |format|
      if @statistic.update_attributes(params[:statistic])
        format.html { redirect_to @statistic, notice: 'Statistic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics/1
  # DELETE /statistics/1.json
  def destroy
    render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) and return if !user_signed_in?
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false) and return unless current_user.email == "sven.clement@gmail.com"
    @statistic = Statistic.find(params[:id])
    @statistic.destroy

    respond_to do |format|
      format.html { redirect_to statistics_url }
      format.json { head :no_content }
    end
  end
end
