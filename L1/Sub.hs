
module Sub
 (
  sub
 )

where


import Aux
import Alg
import Exc
import Sig
import Small
import Type


------------------------------------------------------------------------------------------
-- ALGORITMO DE SUBESTRUCTURALIZACIÓN
------------------------------------------------------------------------------------------
--auxiliar
-- no se usa
-- se pensó que de las 62 subestructuralizaciones de mersort había repetidos, pero 
-- resultó que eran todas distintas
depurar [] = []
depurar ((e,t) : ets) = if estaPar (e,t) ets then ets else (e,t) : depurar ets
 where estaPar (e,t) ets = esta e (map fst ets) && esta t (map snd ets)
 ------------------------------------------------------------------------------------------
 
subExc :: Pi -> Exc -> [(Exc,Tau)]

subExc pi (Var x) = [(Var x,tau pi x)]
-- los operadores booleanos son subestructurales de prepo
subExc pi (O (o,Q q "bool") es) = [(O (o,Q Su "bool") [],Q Su "bool")]
subExc pi (O (o,Fun (Q q0 s) (Q q "bool")) es) = map (\(i,d,es) -> (O (o,Fun d i) es,i)) [(Q Su "bool",d,[e]) | (e,d) <- ets ] 
                                                     where ets = subExc pi (head es) 
subExc pi (O (o,Fun (Prod [s0,s1]) (Q q "bool")) es) = map (\(i,ts,es) -> (O (o,Fun (Prod ts) i) es,i)) (filter (\(t,ts,es) -> True) (paresSu))
                                     where
                                      pares     = map (\((e1,t1),(e2,t2)) ->([t1,t2],[e1,e2])) [(p1,p2) | p1 <- ets1, p2 <- ets2]
                                      paresSu   = map (\(ts,es) -> (Q Su "bool",ts,es)) pares
                                      ets1      = subExc (head pis) (head es) 
                                      ets2      = subExc (head (tail pis)) (head (tail es)) 
                                      pis       = spl 2 [fv (head es),fv (head (tail es))] pi
subExc pi (O (o,t) es) = 
    case (qTau (iop t),length (dop t)) of
       (Un,0)     -> [(O (o,putTau Un t)[],putTau Un t) , (O (o,putTau Su t) [],putTau Su t)]
       (q,0)      -> [(O (o,putTau q t) [],putTau q t)]
       (Un,1)     ->  map (\(i,d,es) -> (O (o,Fun d i) es,i)) 
                          ([(putTau Un (iop t),d,[e]) | (e,d) <- ets ] ++ [(putTau Su (iop t),d,[e]) | (e,d) <- ets ]) 
                      where ets = subExc pi (head es)
       (q,1)      ->  map (\(i,d,es) -> (O (o,Fun d i) es,i)) [(putTau q (iop t),d,[e]) | (e,d) <- ets ]
                      where ets = subExc pi (head es)
       (q,2)      -> case q of
                       Un ->  map (\(i,ts,es) -> (O (o,Fun (Prod ts) i) es,i)) (filter (\(t,ts,es) -> True)  (pares Un ++ pares Su) )
                       _  ->  map (\(i,ts,es) -> (O (o,Fun (Prod ts) i) es,i)) (filter (\(t,ts,es) -> True) (pares q))
                      where
                       ps        = map (\((e1,t1),(e2,t2)) ->([t1,t2],[e1,e2])) [(p1,p2) | p1 <- ets1, p2 <- ets2]
                       pares q   = map (\(ts,es) -> (putTau q (iop t),ts,es)) ps
                       ets1      = subExc (head pis) (head es) 
                       ets2      = subExc (head (tail pis)) (head (tail es)) 
                       pis       = if o==ConOp then spl 2 [fv (head es),fv (head (tail es))] pi 
                                                      else sspl 2 [fv (head es),fv (head (tail es))] pi 
       (q,3)     -> case q of
                      Un ->  map (\(t,ts,es) -> (O (o,Fun (Prod ts) t) es,t)) (filter (\(t,ts,es) -> True)  (triples Un ++ triples Su))
                      _  ->  map (\(t,ts,es) -> (O (o,Fun (Prod ts) t) es,t)) (filter (\(t,ts,es) -> True) (triples q))
                     where
                       ts     = map (\((e1,t1),(e2,t2),(e3,t3)) ->([t1,t2,t3],[e1,e2,e3]))  
                                     [(p1,p2,p3) | p1 <- ets1, p2 <- ets2, p3 <- ets3]
                       triples q   = map (\(ts,es) -> (putTau q (iop t),ts,es)) ts
                       ets1      = subExc (head pis) (head es) 
                       ets2      = subExc (head (tail pis)) (head (tail es)) 
                       ets3      = subExc (head ((tail.tail) pis)) (head ((tail.tail) es)) 
                       pis       = if o==DConOp then spl 3 [fv (head es),fv (head (tail es)),fv (head ((tail.tail) es))] pi 
                                                       else sspl 3 [fv (head es),fv (head (tail es)),fv (head ((tail.tail) es))] pi 
       _    -> error ("Sub/subExc: no hay matching para el tipo de operación " ++ show t)

subExc pi (Tup es) = if b then [(Tup es,Prod ts) | (es,ts) <- dosec etss ] else []
 where etss = map (\(pi',e) -> subExc pi' e) (zip (spl (length es) (map fv es) pi) es)
       b    = and (map (not.((==) 0)) (map length etss))

subExc pi (App f e) = {-error (show e ++ "\n" ++ show (tau pi f) ++ "\n" ++
                               editTaus (map snd [(App f e',t') | (e',t') <- subExc pi e, True || t'==(dom (tau pi f)) ])  
                            )-}
                      case tau pi f of 
                             Fun d i ->  [(App f e',i) | (e',t') <- subExc pi e, t'==d ]
                             _       ->  error ("Sub/subExc: " ++  show (tau pi f ) ++ " debería ser función") 

subExc pi (Let p e1 e2) = concat [ [(Let p e e',t') | (e',t') <- ets ] | (e,ets) <- etss ] 
 where ets1 = subExc pi1 e1
       etss = map ( \(e,t) -> (e,subExc (comaPip pi2 p t) e2) 
                  )
                  ets1    
       pis       = spl 2 [fv e1,quitar (fv e2) (fv p)] pi
       pi1       = head pis
       pi2       = head (tail pis)


subExc pi (Case q0 e1 e2 p e3) = --error (editPi pi1 ++ "\n" ++ editPi pi2)
                                 concat [ [ (Case (qTau t) e e' p e'',t'') |  (e',t') <- ets2 , (e'',t'') <- ets ,  t'==t'' ] 
                                        |  (e,ets,t) <- etss
                                        ] 
 where ets1      = subExc pi1 e1
       ets2      = subExc pi2 e2
       etss      = map (\(e,t) -> (e,subExc (comaPip pi2  p (Prod [elType (tkTau pi e),(tkTau pi e)])) e3,t) 
                       )
                       ets1
       pis        = --spl 3 [fv e1, fv e2, quitar (fv e3) (fv p)] pi
                    spl 2 [fv e1,union [fv e2,quitar (fv e3) (fv p)]] pi
       pi1        = head pis
       pi2        = head (tail pis)
       --pi3        = head (tail (tail pis))
       elType (List q t) = t
       elType t = error ("Exc elType: el tipo no es lista " ++ show t)
              
subExc pi (If e1 e2 e3) = [ (If e e' e'',t') |  (e,t) <- ets1, (e',e'',t',t'') <- list ] 
 where ets1      = subExc pi1 e1
       ets2      = subExc pi2 e2
       ets3      = subExc pi2 e3
       pis       = spl 2 [fv e1, union[fv e2,fv e3]] pi
       pi1       = head pis
       pi2       = head (tail pis)
       list      = filter (\(e',e'',t',t'') -> t' == t'') [(e',e'',t',t'') | (e',t') <- ets2, (e'',t'') <- ets3 ] 

subExc pi e = error ("Sub subExc: sin definición " ++ show e)

-- Subestructuralización de un programa

subV pi (f,Vf p e) = [(f,Vf p e') | (e',t') <- subExc (comaPip pi p (dom tf)) e,  t'==(im tf)  ]
                        where tf = tau pi f
subV pi (x,v)        = [(x,v)]

subStr pi [] = [[]]
subStr pi (p:str) = ccat (subV pi p) (subStr pi str)
 where ccat [] strs     = []
       ccat [p] strs    = map ((:) p) strs
       ccat (p:ps) strs = map ((:) p) strs ++ ccat ps strs

sub :: Pi -> (Str,Exc) -> [(Str,Exc,Tau)]
sub pi (str,e) =  if null vs then ccat (subStr (pi_un pi) str) (subExc pi e)
                              else error ("no se puede subestructuralizar:\n" ++ 
                                         "hay variables subestructurales que no son parámetro en funciones: " ++ editss vs)
 where ccat [] ets         = []
       ccat envs []        = []
       ccat [str] ets      = map (\(e,t) -> (str,e,t)) ets                   
       ccat (str:strs) ets = map (\(e,t) -> (str,e,t)) ets ++ ccat strs ets  
       vs = quitar (concat (map f str))  (fvPi (pi_un pi)) 
       f (x,Vf p e) = quitar (fv e) (fv p)
       f (x,v) = []



------------------------------------------------------------------------------------------
-- auxiliares

texto [] = []
texto (t:[]) = t
texto ([]:ts) = texto ts
texto (t:ts) = t ++ "\n" ++ texto ts

       
shq Un = "un"
shq (Gl (Var x)) = x
shq q = error ("Type shq : calificador " ++ show q)   
-----------------------------------------------------------------------------
-- Funciones auxiliares para tipado subestructural

un (Q Un s) = True
un (Q U_ s) = True
un (Q Hi s) = True
un (Q Su s)  = False
un (Prod tys) = and (map un tys)
un (Fun tau tau') = True

unpi pi = and (map (\(p,lt) -> un lt) pi)
pi_un pi = filter (\(p,lt) -> un lt) pi


