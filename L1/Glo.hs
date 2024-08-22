
module Glo
 (
  glo
 )

where


import Aux
import Alg
import Exc
import Sig
import Small
import Type

  
------------------------------------------------------------------------------------------
-- ALGORITMO DE GLOBALIZACIÓN
------------------------------------------------------------------------------------------


-- pasaje de parámetros sin sharing: sólo para quitar algunas combinaciones en gloexc
nosh [] = True
nosh [Q q s] = True
nosh [t1,t2] = case (qTau t1,qTau t2) of 
                           (Gl (Var x),Gl (Var y))  -> not (x==y)
                           _            -> True
nosh [t1,t2,t3] = case (qTau t1,qTau t2,qTau t3) of 
                                  (Gl (Var x),Gl (Var y),Gl (Var z))  ->  not (x==y) && not (x==z) && not(y==z)
                                  (q1,Gl (Var y),Gl (Var z))          ->  not(y==z)
                                  (Gl (Var x),q2,Gl (Var z))          ->  not(x==z)
                                  (Gl (Var x),Gl (Var y),q3)          ->  not(x==y)
                                  (q1,q2,q3)        ->  True
nosh ts = error "nosh"

------------------------------
--  globalización ------------
------------------------------  

--PARA GLOBALIZACIÓN
-- globales de un entorno de tipo básico o lista (tipos globalizables)
-- gl (q P) = Gl^P del artículo para cualquier q
-- CUIDADO gl no es Gl del artículo: Gl^(x P) pi = {x} intersección Gl^P pi
-- en al prototipo el trabajo de Gl lo hace dosq (archivo Glo.hs) 
gl t [] = []
gl (Q q s) ((p,Q (Gl (Var x)) s'):pi)       = if s==s' then x : gl (Q q s) pi else gl (Q q s) pi
gl (List q s) ((p,List (Gl (Var x)) s'):pi) = if s==s' then x : gl (List q s) pi else gl (List q s) pi
gl t ((p,t'):pi)                            = gl t pi

-- Ajuste de tipo al patrón global
-- putglTau p t xs = pp . t  donde pp = p|_xs 
putglTau (VP x) (Q q s) xs = case q of
                             Lo -> if esta x xs then Q (Gl (Var x)) s else Q q s
                             _  -> Q q s
putglTau (VP x) (List q s) xs = case q of
                             Lo -> if esta x xs then List (Gl (Var x)) s else List q s
                             _  -> List q s
putglTau (P []) t xs = t
putglTau (P ps) (Prod lts) xs = Prod (map (\(p,lt) -> putglTau p lt xs) (zip ps lts))
putglTau (VP x) (Fun d i) xs = Fun d i
putglTau (VP x) (FO q d i) xs = FO q d i
putglTau p lt xs = error ("Exc:putglTau: no hay compatibilidad " ++ show p ++ "  " ++ show lt) 

-- Ajuste de entorno: sincerar las variables globales de t en pi
-- pi^xs  = putglPi pi xs
putglPi [] xs = []
putglPi ((x,Q q s):pi) xs = (x,Q (if esta x xs then Gl (Var x) else q) s) : putglPi pi xs
putglPi ((x,List q s):pi) xs = (x,List (if esta x xs then Gl (Var x) else q) s) : putglPi pi xs
putglPi ((x,Fun d i):pi) xs = (x,Fun d i) : putglPi pi xs
putglPi ((x,FO p d i):pi) xs = (x,FO p d' i) : putglPi pi xs
 where d'  = putglTau p d xs'
       xs' = filter (\x -> esta x (fv i)) xs
putglPi ((x,t):pi) xs = error ("Exc:putglPi: " ++ show t)       

--AUXILIAR hacer secuencia de calififcadores para los operadores
-- pone calificadores posibles para el input e de tipo d, suponiendo que la operación se califica g (output)
-- caso input operador
dosq pi e d Lo = [Lo] ++ [Gl (Var z) | z <- gl d pi, esta z (fv e ++ fv (tkTau pi e))]
dosq pi e d (Gl (Var x)) = case (simTau te tx,te) of 
                           (True,Q (Gl (Var y)) s)    -> [Gl (Var y)]
                           (True,List (Gl (Var y)) s) -> Lo : [Gl (Var z) | z <- gl d pi, esta z (fv e ++ fv te)]  
                           (_,_)                      -> Lo : [Gl (Var z) | z <- gl d pi, esta z (fv e ++ fv te)]
 where te = tkTau pi e
       tx = tau pi x

-- Auxiliar: igual tipo salvo calificadores
simTau (Q q s) (Q q' s') = s==s'
simTau (Prod lts) (Prod lts') = (length lts == length lts') 
                                        && and (map (\(lt,lt')-> simTau lt lt') (zip lts lts'))
simTau (Fun lt1 lt2) (Fun lt1' lt2') = simTau lt1 lt1' && simTau lt2 lt2'
simTau (List q t) (List q' t') =  simTau t t'
simTau (FO p t t1) (FO p' t' t1') = p==p' && simTau t t' && simTau t1 t1'  -- INCOMPLETO!!!!
simTau _ _ = False

---------------------------------------------------------------------
-- AUXILIARES

showQInput :: [[Qu]] -> String
showQInput gss = concat (map (\gs-> editss (map show gs)++"\n") gss)

chk pi e t gss ps = if length ps == 0 
                    then error ("en el entorno\n[" ++ editPi pi ++ "]\n\nla expresión  " ++ show e ++ ":" ++ show t ++ 
                                " no globaliza\n" ++
                                "En caso de ser operador o constructor, las secuencias de calificadores para los inputs son:\n" ++
                                showQInput gss)
                    else ps

-- desglobalización: permitir que una variable de tipo x P sea un globalización de tipo lo P, funciona para los input
-- poniendo dgloExc en la definición de ets (caso operadores) se obtienen más globalizaciones, pero explota
-- se logra por ejemplo que fact3, fib1, etc tengan una globalización con (==0) : lo int -> lo bool
-- esto permite relajar el algoritmo (poner mtkTau en lugar de mtkTauf en la regla de operadores
-- con esta modificación muygl.gl lograría tipar con el algoritmo (todo local)
--dgloExc pi (Var x) t = if simTau t (tau pi x) then [Var x] else []                                                               
--dgloExc pi e t = gloExc pi e t
---------------------------------------------------------------------
                                                                   
--glo :: Pi -> (Str,Exc) -> Tau -> [(Str,Exc)]
-- NO VALE : si e' está en glo pi (str,e) t entonces pi |- e : t

glo pi (str,e) t =  filter test (ccat (gloPi pi str) (gloExc pi e t)) 
 where ccat [] ets         = []
       ccat strs []        = []
       ccat [str] ets      = map (\e -> (str,e)) ets                  
       ccat (str:strs) ets = map (\e -> (str,e)) ets ++ ccat strs ets 
       test s = True 

gloExc :: Pi -> Exc -> Tau -> [Exc]

gloExc pi (Var x) t = if tau pi x <= t then [Var x] else []
                      
gloExc pi (O (o,t) es) t' = 
  case (iop t,dop t,qTau t') of
       (i,[],g)     -> chk pi (O (o,t) es) t' [] [O (o,putg g i)  []]
       (i,[d],g)    -> chk pi (O (o,t) es) t' [gs] [O (o,Fun b (putg g (iop t)))  [e] | (b,e) <- ets d (head es) gs ]
                            where e0 = head es
                                  gs = dosq pi e0 d g 
       (i,[d1,d2],g)    -> chk pi (O (o,t) es) t' [gs1,gs2] [O (o, Fun (Prod [t1,t2]) (putg g i)) [e1,e2] |
                                                              (t1,e1) <- ets d1 e01 gs1, (t2,e2) <- ets d2 e02 gs2, nosh [t1,t2] ]
                            where e01 = head es
                                  e02 = head (tail es)
                                  gs1 = dosq pi e01 d1 g  
                                  gs2 = if o==ConOp then [Lo] else dosq pi e02 d2 g  
       (i,[d1,d2,d3],g) -> chk pi (O (o,t) es) t' [gs1,gs2,gs3] [O (o, Fun (Prod [t1,t2,t3]) (putg g i)) [e1,e2,e3] |
                                       (t1,e1) <- ets d1 e01 gs1, (t2,e2) <- ets d2 e02 gs2, 
                                       (t3,e3) <- ets d3 e03 gs3, nosh [t1,t2,t3] ]
                            where e01 = head es
                                  e02 = head (tail es)
                                  e03 = head ((tail.tail) es)
                                  gs1 = dosq pi e01 d1 g  
                                  gs2 = dosq pi e02 d2 g 
                                  gs3 = if o==DConOp then [Lo] else dosq pi e03 d3 g 
       _                -> error "gloExc: caso operador"
   where ets d e gs = concat [[(putg g d,e) | e <- gloExc pi e (putg g d)] | g <- gs]  
         putg g (Q q a) = Q g a
         putg g (List q t) = List g t
         putg g t = error ("Glo/putg en gloExc caso operador: no tiene tipo de input de op ni cons")


gloExc pi (Tup es) (Prod ts) =   --case es of
                                  --[e1,Var "zs"] -> error (show (map length etss))       
                                 -- _             -> 
                                                   if b then chk pi (Tup es) (Prod ts) [] [Tup es | es <- dosec_ etss ] else []
       where etss = map (\(e,t) -> gloExc pi e t) (zip es ts) 
             b    = and (map (not.((==) 0)) (map length etss))

gloExc pi (App f e) t = chk pi (App f e) t []
                            (case tau pi f of 
                               Fun d i  -> if i==t then [App f e' | e' <- gloExc pi e d  ] else []
                               FO p d i -> if simTau i t   then [App f e' | e' <- gloExc pi e d' ]  else []
                                             where d' = putglTau p d (glPi pi)
                               _        ->  [])

gloExc pi (Case q e1 e2 p e3) t = chk pi (Case q e1 e2 p e3) t [] [ Case Lo e e' p e'' |  e <- ets1, e' <- ets2, e'' <- ets3 ] 
 where --gs        = [Lo] -- Lo : [Gl x | x <- gl "bool" pi]
       tl        = case tkTau pi e1 of
                    List q s  -> List Lo s
                    _         -> error ("Glo/gloExc: caso case, tipo incorrecto")  
       ets1      = gloExc pi e1 (tkTau pi e1)  
       ets2      = gloExc pi e2 t
       ets3      = gloExc (comaPip pi p (Prod [elType tl,tl])) e3 t
       elType (List q t) = t
       elType t = error ("Exc elType: el tipo no es lista " ++ show t)

gloExc pi (Let p e1 e2) t = chk pi (Let p e1 e2) t  [] [ Let p e e' | e <- ets1, e' <- ets2 ] 

 where t1   = putglTau p (tkTau pi e1) (glPi pi)  -- necesario, ver fib5
              --if (putglTau p (tkTau pi e1)==(glPi pi)) (tkTau pi e1) then (tkTau pi e1) 
              --                                                              else error (show (putglTau p (tkTau pi e1) (glPi pi))
              --                                                                     ++"\n" ++ show (tkTau pi e1) ++"\n" ++ editPi pi)  
       ets1 = gloExc pi e1 t1   
       ets2 = gloExc (comaPip pi p t1) e2 t

gloExc pi (If (O (EqOp 0,t0) es) e2 e3) t = chk pi (If (O (EqOp 0,t0) es) e2 e3) t []
                                        [ If e e' e'' |  e <- ets1, e' <- ets2, e'' <- ets3 ]
 where gs        = [Lo] -- Lo : [Gl x | x <- gl "bool" pi]
       ets1      = concat [gloExc pi (O (EqOp 0,t0) es) (Q g "bool") | g <- gs] 
       ets2      = gloExc pi e2 t
       ets3      = gloExc pi e3 t
gloExc pi (If e1 e2 e3) t = chk pi (If e1 e2 e3) t [] [ If e e' e'' |  e <- ets1, e' <- ets2, e'' <- ets3 ] 
 where gs        = [Lo] -- Lo : [Gl x | x <- gl "bool" pi]
       ets1      = concat [gloExc pi e1 (Q g "bool") | g <- gs] 
       ets2      = gloExc pi e2 t
       ets3      = gloExc pi e3 t


gloExc pi e t = error ("Glo/gloExc: " ++ show e ++ " : " ++ show t )


-- Globalización de un programa

gloV pi (f,Vf p e) =  [(f,Vf p e') | e' <- gloExc pi' e (im t) ] --- error (show (glFun pi1 t) ++ editPi pi') 
                       where t = tau pi f
                             --en pi' se transparenta las variables globales de im t y se cambian en el dominio
                             pi' = putglPi (comaPip pi p (dom t)) (fv (im t))
                             --pi' = comaPip pi1 (VP f) (putglFun pi1 t) 
gloV pi (x,v)      = [(x,v)]

gloPi pi [] = [[]]
gloPi pi (p:str) = ccat (gloV pi p) (gloPi pi str)
 where ccat [] strs     = []
       ccat [p] strs    = map ((:) p) strs
       ccat (p:ps) strs = map ((:) p) strs ++ ccat ps strs


---------------------------------------------------------------------------------------
-- auxiliar

texto [] = []
texto (t:[]) = t
texto ([]:ts) = texto ts
texto (t:ts) = t ++ "\n" ++ texto ts

