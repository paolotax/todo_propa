# encoding: utf-8

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
  
  def baule_tag(cliente, options = {})
    
    if cliente.nel_baule
      link_to cliente.nel_baule, method: "delete", remote: true, class: "baule_btn #{options[:class_scarica]}" do
        content_tag( :i, "", class: 'icon-truck') + "Scarica Baule"
      end  
    else

      render "visite/nel_baule"
    end
  end
    

  def new_button(path) 
    content_for :add_button do
      render partial: 'shared/add_button', locals: { path: path }
    end
  end
  
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(text, *options).to_html.html_safe
  end

  def manifest_attribute
    Rails.env.production? ? 'manifest="/production.appcache"'.html_safe : ''
  end

  def episode_video_tag(episode)
    video_tag episode.asset_url("videos"), :poster => "/assets/episodes/posters/loading#{800 if episode.legacy?}.png", :width => (episode.legacy? ? 800 : 960), :height => 600
  end

  def video_tag(path, options = {})
    xml = Builder::XmlMarkup.new
    xml.video :width => options[:width], :height => options[:height], :poster => options[:poster], :controls => "controls", :preload => "none" do
      xml.source :src => "#{path}.mp4", :type => "video/mp4"
      xml.source :src => "#{path}.m4v", :type => "video/mp4"
      xml.source :src => "#{path}.webm", :type => "video/webm"
      xml.source :src => "#{path}.ogv", :type => "video/ogg"
    end.html_safe
  end

  
  def pretty_prezzo( prezzo, *args )
    content_tag :div, class: 'pretty-prezzo' do
      content_tag :strong do
        raw(
          "€ #{prezzo.to_i.to_s}," +
          content_tag( :sup, ((prezzo - prezzo.to_i) * 100).to_i.to_s.ljust(2, '0')  )
        )
      end  
    end
  end
  
  def copertina(libro)
    libro.image ||= asset_path('default-copertina.gif')
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
