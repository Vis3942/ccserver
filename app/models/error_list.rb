class ErrorList < ApplicationRecord
    validates :code, uniqueness: true

    enum shutdown: {
        no: "no", 
        yes: "yes"
    }	

end
