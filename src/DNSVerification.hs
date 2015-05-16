module DNSVerification(verify) where

import Data.ByteString.Char8 (ByteString, unpack)
import Data.List (isInfixOf)
import Network.DNS

type Token = String

type TXTRecord = ByteString

findTXTRecords :: Domain -> IO (Either DNSError [TXTRecord])
findTXTRecords d = do
  rs <- makeResolvSeed defaultResolvConf
  withResolver rs $ \r -> lookupTXT r d

checkForToken :: Token -> [TXTRecord] -> Bool
checkForToken t = any containsToken
  where containsToken r = t `isInfixOf` unpack r

verify :: Domain -> Token -> IO (Either DNSError Bool)
verify d t = do
  records <- findTXTRecords d
  return $ checkForToken t <$> records
