% Strategies for Constraint Functional-Logic Programming
% Sebastian Fischer (sebf@informatik.uni-kiel.de)

This module exposes strategies for CFLP by re-exporting them from
other modules in this package.

> {-# LANGUAGE
>       FlexibleInstances
>   #-}
>
> module CFLP.Strategies (
>
>   dfs, limDFS, iterDFS, diag, rndDFS
>
>  ) where
>
> import Control.Monad.Omega
> import Control.Monad.Logic
>
> import CFLP
> import CFLP.Strategies.CallTimeChoice
> import CFLP.Strategies.DepthCounter
> import CFLP.Strategies.DepthLimit
> import CFLP.Strategies.Random

We provide shortcuts for useful strategies.

depth-first search:

> instance Enumerable []    where enumeration = id
> instance Enumerable Logic where enumeration = observeAll
>
> dfs :: [CTC (Monadic (UpdateT (StoreCTC ()) Logic)) (StoreCTC ())]
> dfs = [callTimeChoice monadic]

depth-first search with limited depth:

> limDFS :: Int
>        -> [CTC (Depth (DepthLim (Monadic
>                 (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) Logic))))
>                (StoreCTC (DepthCtx (DepthLimCtx ())))]
> limDFS l = [limitedDepthFirstSearch l]
>
> limitedDepthFirstSearch
>  :: Int -> CTC (Depth (DepthLim (Monadic
>                  (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) Logic))))
>                (StoreCTC (DepthCtx (DepthLimCtx ())))
> limitedDepthFirstSearch l
>   = callTimeChoice . countDepth . limitDepth l $ monadic

iterative deepening depth-first search:

> iterDFS :: [CTC (Depth (DepthLim (Monadic
>                   (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) Logic))))
>                 (StoreCTC (DepthCtx (DepthLimCtx ())))]
> iterDFS = map limitedDepthFirstSearch [0..]

Fair diagonalization by Luke Palmer:

> instance Enumerable Omega where enumeration = runOmega
>
> diag :: [CTC (Monadic (UpdateT (StoreCTC ()) Omega)) (StoreCTC ())]
> diag = [callTimeChoice monadic]

We combine randomization with depth-first search. Here, it is crucial
to use the call-time choice transformer *before* the randomizer
shuffles choices.

> rndDFS :: [CTC (Rnd (Monadic (UpdateT (StoreCTC (RndCtx ())) Logic)))
>                (StoreCTC (RndCtx ()))]
> rndDFS = [callTimeChoice . randomise $ monadic]

Finally, we provide instances for the type class `CFLP` that is a
shortcut for the class constraints of CFLP computations.

> instance (MonadPlus m, Enumerable m)
>       => CFLP (CTC (Monadic (UpdateT (StoreCTC ()) m)))
>
> instance (MonadPlus m, Enumerable m)
>       => CFLP (CTC (Depth (DepthLim (Monadic
>                     (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) m)))))
>
> instance (MonadPlus m, Enumerable m)
>       => CFLP (CTC (Rnd (Monadic (UpdateT (StoreCTC (RndCtx ())) m))))

