class ExternalUser < ActiveRecord::Base
  belongs_to :user
  attr_accessible :opaque_id, :user_id
  
  def self.create_from_lti(params)
    name      = params[:lis_person_name_full]
    email     = params[:lis_person_contact_email_primary]  # ...
    password  = params[:oauth_nounce]

    # needs to be unique...
    username  = name.gsub(/\s+/, '')

    # possibly use these for what discussion to put them in...
    context_title = params[:context_title]  # "Life Hacking 101"
    context_id = params[:context_id]


    # if a discussion with that name exists, join it
    # else, create a discussion...

    user = User.new.tap do |u|
      u.name = name
      u.email = email
      u.password = password
      u.username = username
      u.active = true
    end

    if user.save
      ExternalUser.create(opaque_id: params[:user_id], user_id: user.id) if user.save
    else
      nil
      # Raise exception about what was invalid on the model
    end
  end
end
