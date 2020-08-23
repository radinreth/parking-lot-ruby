# patch
class String
  def classify
    self.split('/').collect do |c|
      c.split('_').collect(&:capitalize).join
    end.join('::')
  end
end
