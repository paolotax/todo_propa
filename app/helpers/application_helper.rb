module ApplicationHelper
  
  require 'digest/md5'
  
  def field(f, attribute, options = {})
    #return if f.object.new_record? && cannot?(:create, f.object, attribute)
    #return if !f.object.new_record? && cannot?(:update, f.object, attribute)
    label_name = options.delete(:label)
    label_name = "#{attribute.to_s.humanize}" if label_name.nil?
    type = options.delete(:type) || :text_field
    content_tag(:div, (f.label(attribute, "#{label_name}:" ) + f.send(type, attribute, options)), :class => "field")
  end
  

  def gravatar(user, options = {})
    email_address = user.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "http://www.gravatar.com/avatar/#{hash}"
    unless options.empty?
      query_string = options.map {|key, value| "#{key}=#{value}"}
      image_src << "?" << query_string.join("&")
    end
    image_tag(image_src)
  end
    
  def gravatar_url(email,options = {})
  	require 'digest/md5'
  	hash = Digest::MD5.hexdigest(email)
  	url = "http://www.gravatar.com/avatar/#{hash}"
  	options.each do |option|
  		option == options.first ? url+="?" : url+="&"
  		key = option[0].to_s
  		value = option[1].to_s
  		url+=key + "=" + value
  	end
  	url
  end
  
end
