{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Web.Scotty as S
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
import Control.Monad.IO.Class (liftIO)

data User = User {
    userId :: Int,
    userName :: String
  } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User

-- type State = [User]

bob = User { userId = 1, userName = "bob" }
jenny = User { userId = 2, userName = "jenny" }
allUsers = [bob, jenny]

findById users id = filter
  (\user -> (userId user == id))
  users

main = do
  putStrLn "charging teleporter..."
  scotty 3000 $ do
    S.get "/users" $ do
      liftIO $ putStrLn "fetching all users..."
      json allUsers
    S.get "/user/:id" $ do
      id <- param "id"
      json $ findById allUsers id
    S.get "/hello/:name" $ do
      name <- param "name"
      text $ "hello " <> name <> "!"


