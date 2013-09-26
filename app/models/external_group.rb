class ExternalGroup < ActiveRecord::Base
  belongs_to :group
  attr_accessible :opaque_id, :group_id

  def self.create_from_lti(params)
    # possibly use these for what discussion to put them in...
    context_title = params[:context_title].to_s.gsub(/\W/,'')  # "Life Hacking 101"
    context_id = params[:context_id]

    group = Group.new :user_id => -1, :name => "#{context_title.slice(0..10)}#{ExternalUser.generate_random_text(3)}"
    group.save!
    ext_group = ExternalGroup.create!(:opaque_id => context_id, :group_id => group.id)
    # create a category that matches the group
    category = group.categories.create!(:user_id => -1, :name => group.name, :read_restricted => true)
    ext_group
  end

  def ensure_group_membership(user)
    # add user to the group if not already a member
    if !user.group_users.where(:group_id => self.group_id).exists?
      user.group_users.create(:group_id => self.group_id)
    end
  end

end
