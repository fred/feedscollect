# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"] =~ /(Mobile\/.+Safari)|(Blackberry)|(Symbian)|(Nokia)/
  end
  
  def remove_child_link(name, f)
    f.hidden_field(:_delete) + link_to_function(name, "remove_fields(this)")
  end
  
  def add_child_link(name, f, method)
    fields = new_child_fields(f, method)
    link_to_function(name, h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
  
  
  def highlight(id)
    if params[:id].to_s==id.to_s
      return "highlight"
    end
  end
  
  def show_admin_content?
    authorized?
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def authorized?
    logged_in? && current_user.admin?
  end


  def boolean_to_image_lock(bol)
    if bol && (bol == true)
      return image_tag("/images/lock22.png", :class => "align-center")
    else
      return nil
    end
  end
  
  def boolean_to_image_small(bol)
    if bol
      return image_tag("/images/yes_small.png", :class => "align-center")
    else
      return image_tag("/images/no_small.png", :class => "align-center")
    end
  end
  
  
  def boolean_to_image_big(bol)
    if bol
      return image_tag("/images/yes.png", :class => "align-center")
    else
      return image_tag("/images/no.png", :class => "align-center")
    end
  end
  
  def boolean_to_word(bol)
    if bol 
      return "Yes"
    else
      return "No"
    end
  end
  
  def boolean_to_word_yes(bol)
    if bol 
      return "Yes"
    else
      return ""
    end
  end
  
  def boolean_to_word_no(bol)
    if bol 
      return ""
    else
      return "No"
    end
  end
  
  def years_array
    years = []
    Time.now.year.downto(1950) do |year|
      years << year.to_s
    end
    years
  end


  def f_to_dec(f, prec=2,sep='.')
    num = f.to_i.to_s
    dig = ((prec-(post=((f*(10**prec)).to_i%(10**prec)).to_s).size).times do post='0'+post end; post)
    return num+sep+dig
  end


  def to_file_size(num)
    case num.to_i
    when 0 
      return "0 byte"
    when 1..1024
      return "1K"
    when 1025..1048576
      kb = num/1024.0
      return "#{f_to_dec(kb)} Kb"
    when 1024577..1049165824
      kb = num/1024.0
      mb = kb / 1024.0
      return "#{f_to_dec(mb)} Mb"
    else
      kb = num/1024.0
      mb = kb / 1024.0
      gb = mb / 1024.0
      return "#{f_to_dec(gb)} Gb"
    end
  end
  
end
