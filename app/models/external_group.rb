class ExternalGroup < ActiveRecord::Base
  belongs_to :group
  attr_accessible :opaque_id, :group_id

  def self.create_from_lti(tp)
    # possibly use these for what discussion to put them in...
    context_title = tp.context_title.to_s.gsub(/\W/,'')  # "Life Hacking 101"
    context_id = tp.context_id
    group = Group.create! :name => "#{context_title.slice(0..10)}#{ExternalUser.generate_random_text(3)}"
    ext_group = ExternalGroup.create!(:opaque_id => context_id, :group_id => group.id)
    ext_group
  end

  def ensure_group_membership(user)
    # add user to the group if not already a member
    if !user.group_users.where(:group_id => self.group_id).exists?
      user.group_users.create(:group_id => self.group_id)
    end
  end

  def ensure_default_category
    # lookup/create a category for the course
    # * category should belong to the group.
    # * permissions prevent non-group members from viewing the category.
    group_name = self.group.name
    category = self.group.categories.where(:name => group_name).first
    category ||= self.group.categories.create!(:name => group_name, :user_id => -1, :read_restricted => true)
    category
  end

end
