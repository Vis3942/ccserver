class Location < ApplicationRecord
  belongs_to :group

  def ss_display_name
    [shipto_qb_name, shipto_qb_address_l1, shipto_qb_city, shipto_qb_state, shipto_qb_zip].join(', ')
  end

end
