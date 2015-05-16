module Main where

import Network.Wai.Middleware.RequestLogger
import Web.Scotty

import Routes (routes)

main :: IO ()
main = scotty 3000 $ do
  middleware logStdoutDev
  routes
