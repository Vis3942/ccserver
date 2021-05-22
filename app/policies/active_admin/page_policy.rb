module ActiveAdmin
    class PagePolicy < ApplicationPolicy
    def show?
        case record.name
            when "Dashboard"
                true
            else
                false
            end
        end
    end

    def index?
        true
    end

    # class Scope 
    #     def resolve
    #         scope
    #     end
    # end
end