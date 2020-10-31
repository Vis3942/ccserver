module ActiveAdmin
    module Views
      class Header < Component
  
        def build(namespace, menu)
          super(id: "header")
  
          tmpchild = menu.children.keys
          tmpchild.each { |x| menu.children.delete(x) unless x=='dashboard' }

          @namespace = namespace
          @menu = menu
          @utility_menu = @namespace.fetch_menu(:utility_navigation)
          

          @utility_menu.children.delete('current_user')
          if root_path
            @utility_menu.add id: 'home', priority: 20, html_options: {},
                     label: -> { I18n.t 'messages.home' },
                     url: -> { render_or_call_method_or_proc_on self, root_path },
                     if: :current_active_admin_user?
          end
    
          site_title @namespace
          global_navigation @menu, class: 'header-item tabs'
          utility_navigation @utility_menu, id: "utility_nav", class: 'header-item tabs'
        end
  
      end
    end
  end