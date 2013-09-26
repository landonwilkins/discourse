class ExternalUser < ActiveRecord::Base
  belongs_to :user
  attr_accessible :opaque_id, :user_id

  def self.generate_random_text(length=20)
    # alpha numeric text with symbols as well.
    # remove all non-word characters
    text = SecureRandom.base64(length).gsub(/\W/,'')
    # force length to desired size if larger
    text = text.slice(0..length-1) if text.length > length
    text
  end

  def self.create_from_lti(params)
    name      = params[:lis_person_name_full] || "Anonymous+#{generate_random_text(10)}"
    email     = params[:lis_person_contact_email_primary]  || "#{generate_random_text(50)}@invalid.net"
    password  = generate_random_text(130)

    # needs to be unique... content not important
    username  = generate_random_text(14)

    user = User.new.tap do |u|
      u.name = name
      u.email = email
      u.password = password
      u.username = username
      u.active = true
      #u.moderator = true #TODO: if user is a teacher, give moderator privilege
      #u.admin = true #TODO: if user is a canvas administrator, make then an admin in discourse
    end

    if user.save
      ExternalUser.create(opaque_id: params[:user_id], user_id: user.id) if user.save
    else
      nil
      # Raise exception about what was invalid on the model
    end
  end
end
