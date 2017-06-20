class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  ##
  # use to refer to record with more descriptive variable name
  # e.g. write policy_for :post in PostPolicy

  def self.policy_for(record_type)
    define_method(record_type) do
      record
    end
  end

  ##
  # overwrite any of the specified actions with a method
  # which first checks that the current user is not nil

  def self.require_present_user(*actions)
    actions.each do |action|
      action_method = "#{action}?".to_sym
      unless method_defined?(action_method)
        define_method(action_method) do
          user.present?
        end
      else
        other_permissions = "other_#{action}_permissions?".to_sym
        alias_method other_permissions, action_method
        define_method(action_method) do
          user.present? && send(other_permissions)
        end
      end
    end
  end

  ##
  # create methods to check roles, using rolify gem methods
  # e.g. if "admin" is a role, create the method:
  # def admin?
  #   user.has_cached_role? :admin
  # end
  #
  # user has_cached_role? instead of has_role? to use eager loading

  Role.pluck(:name).each do |role_name|
    define_method("#{role_name}?") do
      user.has_cached_role? role_name
    end
  end

  def owner?
    user == record.user
  end
end
