class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'permissions'

  class NotAuthorized < StandardError; end

  rescue_from NotAuthorized do |exception|
    if logged_in?
      respond_to do |format|
        format.html { render 'not_authorized', :status => 403 }
        format.all { render :text => 'You are not authorized to access this section.', :status => 403 }
      end
    else
      error_msg = 'You must be logged in to access this section.'
      respond_to do |format|
        format.html { flash.now[:error] = error_msg; render 'sessions/new', :status => 401 }
        format.all { render :text => error_msg, :status => 401 }
      end
    end
  end

  helper_method :current_user, :logged_in?, :can?, :get_can

  def current_user
    session[:username]
  end

  def logged_in?
    current_user != nil
  end

  def can?(action, resource)
    if not block_given?
      is_authorized(action, resource, get_permissions)
    else
      if can?(action, resource)
        res = yield
        #log(action, resource) if res and action != :read
        return res
      else
        raise NotAuthorized
      end
    end
  end

  def normalize_resource_path(resource)
    File.expand_path(resource, '/') + '/'
  end

  def denormalize_resource_path(resource, resource_prefix)
    resource_prefix = normalize_resource_path(resource_prefix)
    prefix = suffix = 0
    if resource.start_with?(resource_prefix)
      prefix = resource_prefix.length
    end

    if resource[prefix, 1] == '/'
      prefix += 1
    end
    if resource.end_with? '/'
      suffix = 1
    end
    return resource[prefix .. (-1 - suffix)]
  end

  def get_permissions
    roles = ['anonymous']
    if current_user
      roles.concat(Rails.configuration.users[current_user]['roles'])
    end

    @permissions ||= Rails.cache.fetch("#{roles}_permisions", :expires_in => 60.seconds) do
      permissions = []
      roles.each do |role|
        if Rails.configuration.permissions.has_key?(role)
          permissions.concat(Rails.configuration.permissions[role])
        end
      end
      normalize_permissions(permissions)
    end
  end

end
