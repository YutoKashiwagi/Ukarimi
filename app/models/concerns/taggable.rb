module Taggable
  def set_taggable
    self.tag_relationships.each do |relationship|
      relationship.taggable = self
    end
  end
end
