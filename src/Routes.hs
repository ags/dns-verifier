{-# LANGUAGE OverloadedStrings #-}

module Routes where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (object, (.=))
import Data.ByteString.Char8 (pack)
import Network.HTTP.Types (badRequest400)
import Web.Scotty

import qualified DNSVerification as D (verify)

verify :: ActionM ()
verify = do
  domain <- param "domain" `rescue` const next
  token <- param "token" `rescue` const next
  vStatus <- liftIO $ D.verify (pack domain) token
  case vStatus of
    Left e -> json $ object [ "error" .= show e ]
    Right b -> json $ object [ "status" .= show b ]

invalid :: ActionM ()
invalid = do
  status badRequest400
  json $ object [ "error" .= ("Invalid Request." :: String)]

routes :: ScottyM ()
routes = do
  get "/" verify
  get "/" invalid
