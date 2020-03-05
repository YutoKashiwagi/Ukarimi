module Taggable
  def set_taggable
    tag_relationships.each do |relationship|
      relationship.taggable = self
    end
  end
end
