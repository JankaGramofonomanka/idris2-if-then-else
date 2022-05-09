module Hackery

import Data.List

import IfThenElse

data If condT thenT elseT = MkIf condT
data Then condT thenT elseT t = MkThen condT (thenT -> t)

if_ : (impl : IfThenElse condT)
  => condT
  -> If condT (DeconstructThen @{impl}) (DeconstructElse @{impl})

if_ cond = MkIf cond


infixl 5 `then_`
then_ : (impl : IfThenElse condT)
  => If condT (DeconstructThen @{impl}) (DeconstructElse @{impl})
  -> ((DeconstructThen @{impl}) -> t)
  -> Then condT (DeconstructThen @{impl}) (DeconstructElse @{impl}) t

then_ (MkIf cond) thenBody = MkThen cond thenBody


else_ : (impl : IfThenElse condT)
  => Then condT (DeconstructThen @{impl}) (DeconstructElse @{impl}) t
  -> (DeconstructElse @{impl} -> t) -> t
else_ (MkThen cond thenBody) elseBody = ifThenElse cond thenBody elseBody @{impl}



x : String
x = if_     True
    `then_` (\_ => "then")
    `else_` (\_ => "else")

nonempty : (l : List a) -> Maybe (NonEmpty l)
nonempty Nil      = Nothing
nonempty (_ :: _) = Just IsNonEmpty


funcMaybe : List a -> a -> a
funcMaybe l dflt =  if_     (nonempty l)
                    `then_` (\_ => head l)
                    `else_` (\_ => dflt)



produceList : Nat -> List a
produceList n = ?whatever

data Empty : List a -> Type where
  IsEmpty : Empty Nil

decideNonEmpty : (l : List a) -> Either (Empty l) (NonEmpty l)
decideNonEmpty Nil = Left IsEmpty
decideNonEmpty (_ :: _) = Right IsNonEmpty

{--- Doesn't parse for some reason
func : a
func = let
    l1 = produceList 1
    l2 = produceList 2

  in  if_ (decideNonEmpty l1) 
      `then_` (\_ => head l1)
      `else_` (\_ => 
        if_ (decideNonEmpty l2)
        `then_` (\_ => head l2)
        `else_ (\_ => ?something_else)
        )
-}

