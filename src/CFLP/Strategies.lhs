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
>   dfs, limDFS, iterDFS,
>
>   module CFLP.Strategies.DepthFirst,
>   module CFLP.Strategies.CallTimeChoice,
>   module CFLP.Strategies.DepthCounter,
>   module CFLP.Strategies.DepthLimit
>
>  ) where
>
> import Control.Monad
>
> import CFLP
> import CFLP.Strategies.DepthFirst
> import CFLP.Strategies.CallTimeChoice
> import CFLP.Strategies.DepthCounter
> import CFLP.Strategies.DepthLimit

We provide shortcuts for useful strategies.

depth-first search:

> dfs :: [CTC (Monadic (UpdateT (StoreCTC ()) [])) (StoreCTC ())]
> dfs = [callTimeChoice dfsWithEvalTimeChoice]

depth-first search with limited depth:

> limDFS :: Int -> [CTC (Depth (DepthLim (Monadic
>                         (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) []))))
>                       (StoreCTC (DepthCtx (DepthLimCtx ())))]
> limDFS l = [limitedDepthFirstSearch l]
>
> limitedDepthFirstSearch
>  :: Int -> CTC (Depth (DepthLim (Monadic
>                  (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) []))))
>                (StoreCTC (DepthCtx (DepthLimCtx ())))
> limitedDepthFirstSearch l
>   = callTimeChoice.countDepth.limitDepth l$dfsWithEvalTimeChoice

iterative deepening depth-first search:

> iterDFS :: [CTC (Depth (DepthLim (Monadic
>                   (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) []))))
>                 (StoreCTC (DepthCtx (DepthLimCtx ())))]
> iterDFS = map limitedDepthFirstSearch [0..]

Finally, we provide instances for the type class `CFLP` that is a
shortcut for the class constraints of CFLP computations.

> instance (MonadPlus m, Enumerable m)
>       => CFLP (CTC (Monadic (UpdateT (StoreCTC ()) m)))
>
> instance (MonadPlus m, Enumerable m)
>       => CFLP (CTC (Depth (DepthLim (Monadic
>                     (UpdateT (StoreCTC (DepthCtx (DepthLimCtx ()))) m)))))

