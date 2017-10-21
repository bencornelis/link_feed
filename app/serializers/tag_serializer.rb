class TagSerializer < ActiveModel::Serializer
  attributes :id, :text

  def text
    object.name
  end
end
