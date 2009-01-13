% Testing the `cflp` Package
% Sebastian Fischer (sebf@informatik.uni-kiel.de)
% November, 2008

This module is used in the hook that runs the tests for the `cflp`
package.

> import Test.HUnit
> import Control.CFLP.Tests.CallTimeChoice as CTC
> import Control.CFLP.Tests.HigherOrder as HO
>
> main :: IO ()
> main = do
>  runTestTT $ test [CTC.tests,HO.tests]
>  return ()

