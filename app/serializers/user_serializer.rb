class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :discord_id
 end