class BasePresenter
  def initialize(object, template)
    @object   = object
    @template = template
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def method_missing(name, *args, &block)
    @template.send(name, *args, &block)
  end
end
