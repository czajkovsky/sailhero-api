module Users
  class NeighbourSerializer < BaseSerializer
    attributes :id, :name, :surname, :email, :last_position
  end
end
