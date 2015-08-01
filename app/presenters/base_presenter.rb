class BasePresenter
  def initialize(object, template, current_user)
    @object = object
    @template = template
    @current_user = current_user
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def user_logged_in?
    current_user != nil
  end

  def h
    @template
  end
end
