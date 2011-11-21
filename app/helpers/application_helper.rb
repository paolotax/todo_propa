module ApplicationHelper
  
  def field(f, attribute, options = {})
    #return if f.object.new_record? && cannot?(:create, f.object, attribute)
    #return if !f.object.new_record? && cannot?(:update, f.object, attribute)
    label_name = options.delete(:label)
    label_name = "#{attribute.to_s.humanize}" if label_name.nil?
    type = options.delete(:type) || :text_field
    content_tag(:div, (f.label(attribute, "#{label_name}:" ) + f.send(type, attribute, options)), :class => "field")
  end
  
end
