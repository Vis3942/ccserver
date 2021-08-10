module ActiveAdmin
    module Views

      ##
      # The class +Header+ in the +Views+ module ceates a custom clock in the header of the 
      # web application that updates every second. The time displayed in the UTC time.
      # The intended use of this clock is to be able to compare to time based entries in the table

      class Header < Component
  

        def build(namespace, menu)
          super(id: "header")

          script do
            raw "
            function utc_clock_initializer() {
              //var x = new Date();
              var dt_str = (new Date()).toISOString().slice(0, 19).replace('T', ' ');   
              document.getElementsByClassName('utcclock')[0].innerHTML = dt_str;
              setTimeout(updateclock, 1000); // update clock every second
            }
            
            function updateclock() {
              var dt_str = (new Date()).toISOString().slice(0, 19).replace('T', ' ');
              document.getElementsByClassName('utcclock')[0].innerHTML = dt_str;
              setTimeout(updateclock, 1000);
            }
            
            //$(document).on('turbolinks:load', utc_clock_initializer()); 
            //document.addEventListener('load', utc_clock_initializer);         
            //document.getElementById('utcclockid').addEventListener('load', utc_clock_initializer);
            document.body.onload=function() {utc_clock_initializer()};
            //document.addEventListener('load', utc_clock_initializer);
            "
          end
            

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
            
            @utility_menu.add id: 'utcclockid', priority: 20, 
                      label: -> {Time.now.utc.inspect},
                      html_options: {"class" => 'utcclock'},
                      url: -> {},
                      if: :current_active_admin_user?

          end
    
          # if root_path
          # label: -> {Time.now.utc.inspect},
          # end


          site_title @namespace
          global_navigation @menu, class: 'header-item tabs'
          utility_navigation @utility_menu, id: "utility_nav", class: 'header-item tabs'
        end
  
      end
    end
  end