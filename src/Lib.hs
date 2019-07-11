{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( runSQLs
    ) where

import           Control.Monad              (forM_)
import qualified Data.Text                  as T (Text, unpack)
import           Database.PostgreSQL.Simple

_getConnection =
  connect defaultConnectInfo {
              connectHost = "localhost"
            , connectPort = 15432
            , connectUser = "root"
            , connectPassword="password"
            , connectDatabase = "sampledb"
            }

runSQLs = do
  insertRows
  updateRows
  queryRows
  deleteRows
  queryRows

insertRows = do
  conn <- _getConnection

  count <-
    executeMany conn "insert into assets (id, symbol, name) values (?,?,?)"
                    ([ (1, "btc", "Bitcoin")
                     , (2, "ETH", "Ethereum")
                     , (3, "XRP", "XRP")
                     , (4, "BCH", "Bitcoin Cash")
                     , (5, "LTC", "Litecoin")
                     ]::[(Int, T.Text, T.Text)])
  putStrLn $ show count ++ " rows were added."

updateRows = do
  conn <- _getConnection
  count <- execute conn "update assets set symbol='btc' where id=?" (Only (1::Int))
  putStrLn $ show count ++ " rows were updated."

deleteRows = do
  conn <- _getConnection
  count <- execute_ conn "delete from assets where id < 6"
  putStrLn $ show count ++ " rows were deleted"

queryRows :: IO ()
queryRows = do
  conn <- _getConnection
  xs <- query_ conn "select id, symbol, name from assets order by id" :: IO [(Int, T.Text, T.Text)]
  forM_ xs $ \(id, symbol, name) ->
    putStrLn $ "(" ++ show id ++ ", " ++ T.unpack symbol ++ ", " ++ T.unpack name ++ ")"

