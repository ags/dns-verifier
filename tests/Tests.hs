{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Main where

import Network.Wai (Application)
import Web.Scotty (scottyApp)

import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

import Routes

app :: IO Application
app = scottyApp routes

spec :: Spec
spec = with app $ do
  describe "GET /" $ do
    it "responds with a status of True when the token is found" $ do
      get "/?domain=example.com&token=spf" `shouldRespondWith` [json|{status: "True"}|]

    it "responds with a status of False when the token is not found" $ do
      get "/?domain=example.com&token=bob" `shouldRespondWith` [json|{status: "False"}|]

    it "responds with an invalid request error when params are missing" $ do
      get "/" `shouldRespondWith` [json|{error: "Invalid Request."}|] {matchStatus = 400}

main :: IO ()
main = hspec spec
