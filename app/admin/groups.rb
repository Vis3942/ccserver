ActiveAdmin.register Group do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :account_qb_id, :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:account_qb_id, :name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  permit_params :account_qb_id, :name

  ## 
  # The +index+ block is used to show the list of groups as a table
  # All customizations to show the value in a user-friendly way would occur in this block

  index do
    selectable_column
    id_column
    column :account_qb_id
    column :name
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
  # The +form+ function displays the individual fields of the Group element

  form do |f| 
    f.semantic_errors  *f.object.errors.keys
    f.inputs "Groups" do
      f.input :account_qb_id
      f.input :name
    end
      f.actions
  end    


  ## 
  # The +controller+ block includes function get_tip_string, 
  # The function +get_tip_string+ is a custom action that retrives the relevant tip for the Groups
  # table from the Tips table

  controller do

    def get_tip_string
      tmp_tip = Tip.find_by_name("GroupTips")
      if tmp_tip.nil?
        "tips not defined"
      else
        tmp_tip.comment
      end
    end

  end

end
