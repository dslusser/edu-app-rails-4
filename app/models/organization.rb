class Organization < ActiveRecord::Base
  # relationships .............................................................
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :api_keys, as: :tokenable
  has_many :lti_apps
  has_many :lti_apps_organizations

  # validations ...............................................................
  validates :name, presence: true

  # public instance methods ...................................................
  def regenerate_api_key
    api_keys.map(&:expire)
    api_keys.create
  end

  def current_api_key
    api_keys.active.first || api_keys.create
  end

  def details
    {
      name: name,
      approval: (is_list_apps_without_approval ? 'Show apps without having to pre-approve them' : 'Require pre-approval before showing apps'),
      date_created: created_at.strftime("%b %d, %Y")
    }
  end

  def add_admin(user)
    member = memberships.where(user_id: user.id).first_or_create
    member.is_admin = true
    member.save
  end

  def reset_whitelist
    # Remove any lti apps that have been flagged as private and don't belong to the 
    lti_apps_organizations.includes(:lti_app).each do |lao|
      if !lao.lti_app.is_public? && lao.lti_app.organization_id != self.id
        lao.destroy
      elsif !lao.lti_app.active?
        lao.destroy
      end
    end

    # Iterate over the public LTI Apps and add them to the whitelist if not already there
    lids = lti_apps_organizations.pluck(:lti_app_id)
    LtiApp.active.public.select('id').each do |app|
      next if lids.include? app.id
      lti_apps_organizations.create(
        lti_app_id: app.id,
        is_visible: self.is_list_apps_without_approval
      )
    end
    self.reload
  end

  def whitelist
    reset_whitelist
    lti_apps_organizations.includes(:lti_app).order('lti_apps.name')
  end

  def to_s
    name
  end
end
