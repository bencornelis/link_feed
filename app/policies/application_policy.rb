class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def self.policy_for(record_type)
    define_method(record_type) do
      record
    end
  end

  def self.create_permission_generator_for(user_type)
    define_singleton_method("permit_#{user_type}_to") do |*actions|
      actions.each do |action|
        action_method = "#{action}?".to_sym

        unless method_defined? action_method
          define_method(action_method) do
            user.present?
          end
        end

        alias_method :other_permissions?, action_method
        define_method(action_method) do
          other_permissions? && send(user_type.to_sym)
        end
      end
    end
  end

  ##
  #  create methods to check roles, using rolify gem methods
  #  e.g. if "admin" is a role, create the method:
  #  def admin?
  #    user.has_role? :admin
  #  end
  #
  # then create a permission generator for each role
  Role.pluck(:name).each do |role_name|
    define_method("#{role_name}?") do
      user.has_role? role_name
    end
    create_permission_generator_for(role_name)
  end

  def owner?
    user == record.user
  end
  create_permission_generator_for("owner")


end
