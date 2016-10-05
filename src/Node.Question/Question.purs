module Node.Question
  ( AnswerHandler
  , question
  ) where

import Prelude
import Control.Monad.Eff (Eff)
import Node.ReadLine (READLINE, Interface, LineHandler)

type AnswerHandler eff a = LineHandler eff a

foreign import question :: forall eff a.
                           Interface
                        -> String
                        -> AnswerHandler ( readline :: READLINE
                                         | eff
                                         ) a
                        -> Eff ( readline :: READLINE
                               | eff
                               ) Unit
