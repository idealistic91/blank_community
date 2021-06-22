class GameSerializer < ActiveModel::Serializer
    attributes :id, :name, :igdb_id
 end