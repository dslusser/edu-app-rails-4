class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :whitelist, :toggle_whitelist_item]
  before_action :authorize
  before_action :set_active_tab
  skip_before_filter :verify_authenticity_token, :only => :toggle_whitelist_item

  # GET /organizations
  def index
    @organizations = current_user.organizations
  end

  # GET /organizations/1
  def show
    @can_manage = current_user.can_manage?(@organization)
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      @organization.add_admin(current_user)
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
  end

  def whitelist
    @whitelist = @organization.whitelist
  end

  def toggle_whitelist_item
    lao = @organization.lti_apps_organizations.where(id: params[:lao_id]).first
    lao.update_attribute(:is_visible, !lao.is_visible)
    render json: lao
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = current_user.organizations.where(id: params[:id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      params.require(:organization).permit(:name, :url, :is_list_anonymous_only, :is_list_apps_without_approval)
    end

    def set_active_tab
      @active_tab = 'my_stuff'
    end
end
