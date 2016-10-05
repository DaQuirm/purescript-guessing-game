module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Random (RANDOM, random)

import Data.Int (floor, fromString)
import Data.Maybe (Maybe(..))
import Data.Either (Either(..), either)
import Data.Options ((:=))

import Node.ReadLine
import Node.Question (question)
import Node.Process (stdin, stdout)

check :: Int -> Int -> Either String String
check guessed guess =
  case compare guess guessed of
    EQ -> Right $ "YAY! It is really " <> show guessed
    LT -> Left "Moar!"
    GT -> Left "Less!"

run :: forall eff. Interface -> Int -> Int -> Eff (readline :: READLINE, console :: CONSOLE | eff) Unit
run interface guessed 0 = do
  log $ "Game Over: it was actually " <> show guessed
  close interface

run interface guessed attempts = do
  question interface "Make a guess: " \answer -> do
    case fromString answer of
      Just number -> do
        let result = check guessed number
        either log log result
        case result of
          Left _ -> do run interface guessed (attempts - 1)
          Right _ -> do close interface
      Nothing -> do
        log "Hey, it's NaN!"
        run interface guessed attempts

main :: Eff (console :: CONSOLE, readline :: READLINE, random :: RANDOM) Unit
main = do
  let numberOfAttempts = 3
  let guessUpperLimit = 10.0
  guessed <- ((*) guessUpperLimit) >>> floor <$> random
  input <- createInterface stdin $ output := stdout
  run input guessed numberOfAttempts
