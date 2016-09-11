{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}

module Model where

import Data.Aeson
import Data.Aeson.Types
import ClassyPrelude.Yesod
import Database.Persist.Sql (fromSqlKey)
import Database.Persist.Quasi
import GHC.Generics
import Model.Types

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")


instance ToJSON (Entity Bid) where
    toJSON (Entity bidId bid) = object
        [ "id"      .= (fromSqlKey bidId)
        , "created" .= bidCreated bid
        , "bidder"    .= bidBidder bid
        ]

instance FromJSON BidType where
    parseJSON = genericParseJSON defaultOptions { fieldLabelModifier = drop 6 }

instance ToJSON BidType where
  toJSON = genericToJSON defaultOptions { fieldLabelModifier = drop 6 }

instance FromJSON Bid where
    parseJSON = genericParseJSON defaultOptions
    -- parseJSON _ = mzero

instance ToJSON Bid where
  toJSON = genericToJSON defaultOptions

-- @todo: Can this be in Model.Types ?
data SseEventName = BidCreate | BidEdit
    deriving (Show, Eq, Enum, Bounded, Read)

-- @todo: Try to derive generic
instance ToJSON (SseEventName) where
    toJSON BidCreate = "BidCreate"
    toJSON BidEdit = "BidEdit"
