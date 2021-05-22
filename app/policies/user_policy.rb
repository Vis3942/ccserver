class UserPolicy < ApplicationPolicy


    def show?
        if @user.admin? || @user.s1? || @user.s2? 
            true
        else
            if @record.is_a?(User)
                @user.id == @record.id
            elsif @record.is_a?(Symbol)
                true
            else
                false
            end
        end
    end

    def index?
        if @user.admin? || @user.s1? || @user.s2? 
            true
        else
            false
        end

    end

    def new?
        create?
    end

    def create?
        @user.admin?
    end

    def edit?
        update?
    end

    def update?
        #@user.admin?
        if @user.admin?  
            true
        else
            if @record.is_a?(User)
                @user.id == @record.id
            else
                false
            end
        end
    end

    def destroy?
        @user.admin?
    end

    def destroy_all?
        @user.admin?
    end

    class Scope < ApplicationPolicy::Scope
        def resolve
            scope
        end
    end
     
end