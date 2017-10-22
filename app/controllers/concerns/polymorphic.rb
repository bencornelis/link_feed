module Polymorphic
  extend ActiveSupport::Concern

  private

  def find_polymorphic_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end