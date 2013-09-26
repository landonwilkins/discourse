require 'ims/lti'
require 'oauth/request_proxy/rack_request'

class LtiAuthController < ApplicationController
  include CurrentUser

  skip_before_filter :redirect_to_login_if_required, :only => [:index]
  skip_before_filter :check_xhr, :only => [:tool_config]

  protect_from_forgery :except => :index

  def index
    tp = IMS::LTI::ToolProvider.new('key', 'shared_secret', params)
    tp.valid_request!(request)
    ext_user = ExternalUser.find_by_opaque_id(tp.user_id) || ExternalUser.create_from_lti(params)
    user = ext_user.user

    # lookup/create the group for the course context
    ext_group = ExternalGroup.find_by_opaque_id(tp.context_id) || ExternalGroup.create_from_lti(params)
    group = ext_group.group

    ext_group.ensure_group_membership(user)
    # find/create a category that matches the group
    category = ext_group.ensure_default_category()

    ##
    # TODO: render error unless u
    #
    ##

    log_on_user user if user
    # Redirect to category for desired context category
    redirect_to "/category/#{category.slug}"
  end

  #def tool_launch
  #  @tp = IMS::LTI::ToolProvider.new('test', 'secret', params)
  #  @tp.valid_request!(request)
  #
  #
  #  @user = User.find_by_my_id_thingy(@tp.user_id)
  #  if !@user
  #    @user = User.create(id_thingy: @tp.user_id, name: @tp.lis_person_name_full)
  #  end
  #
  #  #authenticate
  #  #forward to discus page
  #end
  #
  #def tool_config
  #  host = request.scheme + "://" + request.host_with_port
  #  url = host + "/tool_launch"
  #  tc = IMS::LTI::ToolConfig.new(:title => "Discourse", :launch_url => url)
  #  tc.description = "Use Discourse because it's so cool"
  #  #tc.extend IMS::LTI::Extensions::Canvas::ToolConfig
  #  #tc.canvas_privacy_public!
  #  #tc.canvas_course_navigation!({ enabled: true })
  #
  #  render :xml => tc.to_xml(:indent => 2)
  #end

end