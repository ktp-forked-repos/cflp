% Testing Higher-Order Functional-Logic Operations
% Sebastian Fischer (sebf@informatik.uni-kiel.de)

This module defines tests that show how to define higher-order
functional-logic programs.

> module Control.CFLP.Tests.HigherOrder where
>
> import Control.CFLP
> import Control.CFLP.Tests
> import Test.HUnit
>
> import Prelude hiding ( not, null, head )
>
> tests :: Test
> tests = "higher order" ~: test
>   [ "apply not function" ~: applyNotFunction
>   , "apply binary constructor" ~: applyBinCons
>   , "apply non-deterministic choice" ~: applyChoice
>   , "call-time choice" ~: callTimeChoice
>   ]

The following test simply applies the not function.

> applyNotFunction :: Assertion
> applyNotFunction = assertResults comp [True]
>  where
>   comp = apply (fun not) false

The following test applies the binary list constructor.

> applyBinCons :: Assertion
> applyBinCons = assertResults comp [[True]]
>  where
>   comp cs = withUnique $ \u1 u2 ->
>               apply (apply (fun (^:)) true cs u1) nil cs u2

The following tests applies the binary operator for non-deterministic
choice.

> applyChoice :: Assertion
> applyChoice = assertResults comp [False,True]
>  where
>   comp cs = withUnique $ \u1 u2 ->
>               apply (apply (fun (?)) false cs u1) true cs u2

The following test checks whether call-time choice is still obtained
when applying the choice combinator using higher-order features.

> callTimeChoice :: Assertion
> callTimeChoice = assertResults comp [[False,False],[True,True]]
>  where
>   comp cs = withUnique $ \u1 u2 u3 ->
>               apply (fun two)
>                     (apply (apply (fun (?)) false cs u1) true cs u2) cs u3
>
>   two x = x ^: x ^: nil
