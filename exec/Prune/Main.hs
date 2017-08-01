{-# LANGUAGE DoAndIfThenElse   #-}
{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad.Trans.Resource (runResourceT)
-- import           Data.Semigroup               ((<>))
import           Options.Applicative
import           System.Directory             (doesDirectoryExist)
import           System.Environment           (getArgs)

import           Prune


main :: IO ()
main = let inDBDir = "./chaindata"
           outDBDir = "./pruned_chaindata"
       in do
            args <- getArgs
            if length args == 1
              then do
                let arg = head args
                exists <- doesDirectoryExist inDBDir
                case maybeRead arg :: Maybe Int of
                  Nothing -> putStrLn $ arg <> " is not a positive integer, please \
                                            \ select an appropriate value for the \
                                            \ block number"
                  Just blockNumber ->
                    if exists
                      then runResourceT $ prune inDBDir outDBDir blockNumber
                      else putStrLn $ "Path `" <> inDBDir <> "` to levelDB not found. \
                                  \ Make sure the chaindata directory is in the current \
                                  \ directory"
            else do
              putStrLn "No arguments found."
              putStrLn ""
              putStrLn "Usage - prune <block-number>"

mainTmp :: IO ()
mainTmp = execParser opts >>= (\cli -> runResourceT $ prune (inDBDir cli)
                                                            (outDBDir cli)
                                                            (blockNumber cli))
  where
    opts = info (cliVals <**> helper)
      ( fullDesc
     <> progDesc "Print a greeting for TARGET"
     <> header "hello - a test for optparse-applicative" )

maybeRead :: Read a => String -> Maybe a
maybeRead s = case reads s of
    [(x, "")] -> Just x
    _         -> Nothing


data CLIVals = CLIVals
  { inDBDir     :: String
  , outDBDir    :: String
  , blockNumber :: Int
  }

cliVals :: Parser CLIVals
cliVals = undefined
