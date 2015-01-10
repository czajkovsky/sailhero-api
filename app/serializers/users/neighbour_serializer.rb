module Users
  class NeighbourSerializer < BaseSerializer
    attributes :id, :name, :surname, :email, :avatar_url, :last_position
  end
end
