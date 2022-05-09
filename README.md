This a proof of concept of an idea to generalize if-then-else expressions, 
so that idris would accept other things than booleans as if-then-else 
conditions (especially `Either`s and `Maybe`s) and deconstruct them, so that 
the programmer can access information contained in the condition, 
(the `a` in `Maybe a`), in the "then" and "else" blocks.

In other words I'd like to do this:
```
data Empty : List a -> Type where
  IsEmpty : Empty Nil

decideNonempty : (l : List a) -> Either (Empty l) (NonEmpty l)
decideNonempty Nil      = Left IsEmpty
decideNonempty (_ :: _) = Right IsNonEmpty

func : List a -> a
func l = if decideNonempty l  then head l
--                                 ^^^^^^ here, the `NonEmpty l` contained in 
--                                        `decideNonempty l` is used implicitly

                              else ?something_else
```
