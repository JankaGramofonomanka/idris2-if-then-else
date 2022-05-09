module IfThenElse


-- IfThenElse interface -------------------------------------------------------
public export
interface IfThenElse cond where

    {- `DeconstructThen` / `DeconstructElse` - The type of the value that 
        would be extracted from the if-then-else condition in case it was 
        true / false.

        Often there is nothing to extract, therefore `DeconstructThen` and 
        `DeconstructElse` are equal to `()` by default.
    -}
    
    0 DeconstructThen : Type
    DeconstructThen = ()

    0 DeconstructElse : Type
    DeconstructElse = ()

    decide : cond -> Either DeconstructElse DeconstructThen


{-  The expression
      `if <cond> then <thenBody> else <thenBody>`

    should be equivalent to
      `ifThenElse cond (\_ => thenBody) (\_ => elseBody)`

    There should probably be a syntax for accessing the deconstructed values 
    explicitly, something like this:
      `if <cond> then {thenValue} thenBody else {elseValue} elseBody`, 

    which would be equivalent to:
      `ifThenElse cond (\thenValue => thenBody) (\elseValue => elseBody)`

    There is also the issue of idris allowing multiple implementations of an 
    interface per one type, and the syntax for specifying an exact 
    implementation.
    My first guess is that the syntax in case of if-then-else expressions 
    should look like this:
      `if <cond> @{myImpl} then <thenBody> else <thenBody>`
-}
public export
ifThenElse : (impl : IfThenElse condType)
  => condType
  -> (DeconstructThen @{impl} -> t)
  -> (DeconstructElse @{impl} -> t)
  -> t
ifThenElse cond thenBody elseBody = case decide cond of
  Right valThen => thenBody valThen
  Left  valElse => elseBody valElse


-- Example implementations ----------------------------------------------------
public export
implementation IfThenElse Bool where

  {-  `Bool` doesn't carry any information in it, other then truth / falsehood, 
      therefore, we don't define `DeconstructThen` and `DeconstructElse`
      (that is we leave it at default).
  -}

  decide cond = if cond then Right () else Left ()


public export
implementation IfThenElse (Maybe a) where

  {- `Maybe a` carries additional information, but only in the "true" case, 
      therefore we only define `DeconstructThen`.
  -}

  DeconstructThen = a
  
  decide cond = case cond of
    Nothing   => Left ()
    Just val  => Right val


public export
implementation IfThenElse (Either e a) where

  {-  `Either e a` carries additional information in both the "true" case and 
      the "false" case, therefore we define both `DeconstructThen` and 
      `DeconstructElse`.
  -}

  DeconstructThen = a
  DeconstructElse = e

  decide cond = cond







