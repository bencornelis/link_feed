class ApplicationPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def self.policy_for(record_type)
    define_method(record_type) do
      record
    end
  end

  Role.pluck(:name).each do |role_name|
    method_name = (role_name + "?").to_sym
    define_method(method_name) do
      user.has_role? role_name.to_sym
    end
  end

  # def admin?
  #   user.has_role? :admin
  # end

end
