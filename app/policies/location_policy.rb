class LocationPolicy < ApplicationPolicy

    def show?
        if @user.admin? || @user.s1? || @user.s2? || @user.manufacturingtech? || @user.logistics? || @user.finance?
            true
        end
    end

    def index?
        if @user.admin? || @user.s1? || @user.s2? || @user.manufacturingtech? || @user.logistics? || @user.finance?
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
        @user.admin? || @user.manufacturingtech?
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
