module DashboardHelper

  include Ace::Helper::Builder
  #include Termlib::Helper::Builder
  
  # A simple <div/> to wrap editor
  # to Ace
  def create_ace(src, opt)
    js = ace(src)
    content_tag(:div, js, :id => opt[:id])
  end

  # Include all necessary scripts
  # You can choice your ace theme:
  #
  # - Default: 
  #
  #     <%= coffeesound_js_tags :theme => :monokai %> 
  #     same as
  #     <%= coffeesound_js_tags %>
  #
  # - Custom:
  #   - First include a necessary theme-#{theme}.js file in
  #   /vendor/assets/javascripts
  #
  #     <%= coffeesound_js_tags :theme => :emacs%>
  def coffeepot_tags(opt={:theme => :monokai})
     javascript_include_tag("wavepot-runtime", 
                            #"termlib", 
                            #"termlib-parser", 
                            "ace", 
                            "mode-coffee", 
                            "worker-coffee", 
                            "theme-#{opt[:theme]}", 
                            "lzma_worker", 
                            "lzma2string")
  end

end
