ActiveAdmin.register ErrorList do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :code, :description, :shutdown
  #
  # or
  #
  # permit_params do
  #   permitted = [:code, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  actions :all, except: [:destroy ]

  #index :title => "Error Code List"

  #show :title => "Error Code List"

  ## 
  # The +index+ block is used to show the list of errors as a table

  index do
    selectable_column
    id_column
    column :code
    column :description
    column :shutdown
    actions
    panel "Tips and Hints", :id => "tips-panel" do
      disp_str = controller.get_tip_string()
      num_rows = disp_str.lines.count
      if num_rows > 10
        num_rows = 10
      end
      textarea  disp_str,  style: "width: 100%; max-width: 100%;", rows: num_rows, readonly: true #"tips here"
    end

  end

  ##
  # The +form+ function displays the individual Error List fields
  # The actions on the fields of the Error List depend on the user roles  

  form do |f| 
    f.semantic_errors  *f.object.errors.keys
    if object.new_record?
      f.inputs "Error List" do
        f.input :code
        f.input :description
        f.input :shutdown, :as => :select, :collection => ErrorList.shutdowns
      end
    else
      f.inputs "Error List" do
        f.input :code
        #, :input_html => { :readonly => true }
        f.input :description
        if current_user.admin?
          f.input :shutdown, :as => :select, :collection => ErrorList.shutdowns
        else
          f.input :shutdown, :as => :label #:input_html => { :readonly => true }
        end
      end
    end
    f.actions
  end    

  ## 
  # The +controller+ block get_tip_string function, 
  # The function +get_tip_string+ is a custom action that retrives the relevant tip for the Error List
  # table from the Tips table

  controller do
    def get_tip_string
      tmp_tip = Tip.find_by_name("ErrorListsTips")
      if tmp_tip.nil?
        "tips not defined"
      else
        tmp_tip.comment
      end
    end
    end

end
