

module Aux
 (
  FV(fv), 
  -- manejo de secuencias y secuencias de pares
  dosec_,dosec, 
  -- auxiliares de edición
  editss,formatear,
  -- Operaciones sobre conjuntos (implementados como listas)
  quitar, esta, union
 )

where

import Data.Char

class FV a where 
 fv :: a -> [String]

---------------------------------------------------------------------------
--Auxiliares para manejo de secuencias de pares

-- dosec [[(1,'a'),(2,'b')],[(1,'c')],[(1,'d'),(2,'e'),(3,'f')]] = [ ([1,1,1],['a','c','d']) , ([1,1,2],['a','c','e']) ,...]
dosec = dopar . dosec_ 
-- dosec_ [[(1,'a'),(2,'b')],[(1,'c')],[(1,'d'),(2,'e'),(3,'f')]] =
--        [ [(1,'a'),(1,'c'),(1,'d')] , [(1,'a'),(1,'c'),(2,'e')] , [(1,'a'),(1,'c'),(3,'f')] , [(2,'b'),(1,'c'),(1,'d')] , ...]
dosec_ ((p:[]):[])  = [[p]]
dosec_ ((p:ps):[])  = [p] : dosec_ (ps:[])
dosec_ ((p:[]):pss) = map ((:) p) (dosec_ pss)
dosec_ ((p:ps):pss) = (map ((:) p) (dosec_ pss)) ++ dosec_ (ps:pss)
-- dopar [ [(1,'a'),(1,'c'),(1,'d')] , [(1,'a'),(1,'c'),(2,'e')] ,... ] = [ ([1,1,1],['a','c','d']) , ([1,1,2],['a','c','e']) ,...]
dopar pss = map (\ps -> (map fst ps , map snd ps)) pss

--------------------------------------------------------
-- Auxiliares de edición -------------------------------
editss [] = ""
editss [s] = s
editss (s:ss) = s ++ "," ++ editss ss

formatear n s = if n < length s then s else  s ++ esp (n-length s)
 where esp 0        = ""
       esp n = esp (n-1) ++ " "
 
---------------------------------------------------------------------------
-- operaciones basicas de Conjunto sobre strings --------------------------

esta v []       = False
esta v (u:w)    | v == u      = True
                | otherwise   = esta v w

union xss = depure (concat xss)
 where depure  s = dep [] s 
       dep s' []      = s'
       dep s' (x:s)   = if esta x s' then dep s' s else dep (s'++[x]) s


quitar [] z    = []
quitar w []    = w
quitar w (u:z) = quitar (q w u) z 
                  where q [] v = []
                        q (u:w) v   |u==v      = q w v
                                    |otherwise = u:(q w v)





