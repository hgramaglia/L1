

module Sig -- operaciones con la signatura calificada
 (
  putSigma,putTau,putPi, -- rectifica calificador
  putC,    -- "cargar" la signatura calificada (o no) del archivo, el parsing deja a los operadores triviales
  setminus, -- configurar el menos unario o binario
 )

where

import Aux
import Alg
import Exc

------------------------------------------------------------------------------------------
-- AUXILIAR: rectificar calificador

putTau q (Q q' a) = Q q a
putTau q (Prod ts) = Prod (map (putTau q) ts)
putTau q (Fun t1 t2) = Fun (putTau q t1) (putTau q t2)
putTau q (List q' t) = List q (putTau q t)
putTau q (FO p t t') = FO p (putTau q t) (putTau q t')
putTau q (ApT t e) = error ("putTau: tipo \"app\" : " ++ show (ApT t e))

putSigma q sig = map (\(o,t) -> (o,putTau q t)) sig

putPi q pi = map (\(x,t) -> (x,putTau q t)) pi

------------------------------------------
-- Dotar de calificadores a los operadores
------------------------------------------

-- el parsing deja a todos los operadores irrestrictos, con tipo estandard (int, bool, INT, etc)
-- sig es la signatura extraida del TEP, que involucra sólo a un subconjunto de los operadores que aparecen en el programa
-- Los operadores de sig pueden involucrar tipos un, un! (U_) y su, y pueden repetirse en sig con distinta calificación.  

putC (str,e) sig = (str',e') 
  where (str',sig') = putCStr str sig
        (e',sig'')  = putCexc e sig'

putCexc (O (o,t0) []) sig = (O (o,t) [] , sigt) where (t,sigt) = tkt o sig
-- todos los operadores unarios son tipo signatura 0
putCexc (O (o,t0) [e1]) sig = (O (o,t) [e'] , sig' )
                                   where (t,sigt) = tkt o sig
                                         (e',sig') = putCexc e1 sigt
putCexc (O (o,t0) [e1,e2]) sig = case stOp o of
                                  0 -> (O (o,t) [e1',e2'], sig'' )
                                         where (t,sigt) = tkt o sig
                                               (e1',sig') = putCexc e1 sigt  
                                               (e2',sig'') = putCexc e2 sig'
                                  1 -> (O (o,t) [e1',e2'], sig'' )
                                         where (e1',sig') = putCexc e1 sig  
                                               (t,sigt) = tkt o sig'
                                               (e2',sig'') = putCexc e2 sigt
                                  k -> error ("Sig/putCexc: no hay operador binario de tipo signatura " ++ show k) 

putCexc (O (o,t0) [e1,e2,e3]) sig = case stOp o of
                                     0 -> (O (o,t) [e1',e2',e3'], sig''' )
                                            where (t,sigt) = tkt o sig
                                                  (e1',sig')   = putCexc e1 sigt               
                                                  (e2',sig'')  = putCexc e2 sig'
                                                  (e3',sig''') = putCexc e3 sig''
                                     1 -> (O (o,t) [e1',e2',e3'], sig''' )
                                            where (e1',sig')   = putCexc e1 sig
                                                  (t,sigt) = tkt o sig'
                                                  (e2',sig'')   = putCexc e2 sigt               
                                                  (e3',sig''') = putCexc e3 sig''
                                     2 -> (O (o,t) [e1',e2',e3'], sig''' )
                                            where (e1',sig')   = putCexc e1 sig
                                                  (e2',sig'')   = putCexc e2 sig'               
                                                  (t,sigt) = tkt o sig''
                                                  (e3',sig''') = putCexc e3 sigt
                                     k -> error ("Sig/putCexc: no hay operador ternario de tipo signatura " ++ show k) 
                                                  

putCexc (O (o,t0) es) sig = error ("putCexc: incompatibilidad de aridad, operador " 
                                       ++ codop o ++ ":  "++ editSigma [head sig])
putCexc (Var x) sig = (Var x , sig)
putCexc (Tup es)  sig = (Tup es' , sig') where (es',sig') = putCm es sig
putCexc (App f e) sig =  (App f e' , sig')  where (e',sig') = putCexc e sig
putCexc (If e e0 e1) sig = (If e' e0' e1' , sig''')
  where  (e',sig') = putCexc e sig
         (e0',sig'') = putCexc e0 sig'
         (e1',sig''') = putCexc e1 sig''
putCexc (Let p e0 e1) sig = (Let p e0' e1' , sig'')  
 where   (e0',sig') = putCexc e0 sig
         (e1',sig'') = putCexc e1 sig'
putCexc (Case q e e0 p e1) sig = (Case q e' e0' p e1' , sig''')
  where  (e',sig') = putCexc e sig
         (e0',sig'') = putCexc e0 sig'
         (e1',sig''') = putCexc e1 sig''
putCexc e sig = error ("Sig putCexc : no está definida la función para : " ++ show e) 
         

-- auxiliares 
           
           
tkt o sig =  if esta o (map fst sig) 
             then if o==(fst (head sig)) then (snd (head sig),tail sig)
                  else error ("tkt in putCexc: la signatura no provee tipo para " ++ codop o ++ " sino para " ++ codop (fst (head sig)))
                                    -- ++ "  " ++ concat (map codop ps) ++ "    " ++ editSigma sig)
             else error ("tkt in putCexc: " ++ codop o ++ " no esta en la signatura:\n" ++ editSigma sig)
                     
                                                                  
putCm [] sig  = ([] , sig)
putCm [e] sig = ([e'],sig')  where (e',sig') = putCexc e sig
putCm (e:es) sig = (e':es',sig'')
                   where (e',sig')   = putCexc e sig
                         (es',sig'') = putCm es sig'

putCStr [] sig = ([],sig)
putCStr ((x,v):str) sig = ((x,v'):str' , sig'') 
  where (v',sig') = putCV v sig
        (str',sig'') = putCStr str sig'

putCV (Vi i) sig = (Vi i,sig)
putCV (Vb b) sig = (Vb b,sig)
putCV (Va a) sig = (Va a,sig)  
putCV (Vl a b) sig = (Vl a b,sig)  
putCV (VN) sig = (VN,sig)  
putCV (Vf p e) sig = (Vf p e',sig') where (e',sig') = putCexc e sig 


-- Corregir el signo menos; unario o binario?

setminus [] = []
setminus ((SustrOp,Fun (Q q s) t) : sig) = (AddInvOp,Fun (Q q s) t) : setminus sig
setminus ((o,t) : sig) = (o,t) : setminus sig
 



-- Auxiliar
borrar xs (Q (Gl (Var x)) a) = quitar xs [x]
borrar xs (Q g a) = xs

