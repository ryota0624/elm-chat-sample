module Types.User exposing (..)

type Id = UserId String
idString: Id -> String
idString (UserId str) = str

type alias User = {
  id: Id
  , name: String
  , iconImageUrl: String
  }