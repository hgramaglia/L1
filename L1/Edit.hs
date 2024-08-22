
module Edit
( editPP,meditPP,                 -- programa plus: (pi,str,e,t), se edita con formato TEPT   
  editCom,                        -- edición con forma de comando  
  editPPTest,editTypeTest,        -- edición de chequeo de tipos
  editProt                        -- edición de chequeo de tipos y protección
)
where
import Aux
import Alg
import Exc
import Parser
import Sig
import Small
import Type
import Sub
import Glo


--------------------------------------------------------------------------
-- Edición de programas --------------------------------------------------

{-PP Programa plus = (pi,str,e,t)

TEP Texto estandard de programa:
x=4,
y=1
-----
x+y
-----
+ : (q int,q int) -> q int
-----
x:q int,
y:q int
-----
OJO!! : en str, las variables libres de v, aparecen declaradas antes de x=v

TEPT:
TEP
q int
-----
-}

--edición de PP en formato TEPT
editPP (pi,str,e,t) =  "\n\n" ++
 editStr str                            ++ "\n" ++
 "------------------------------------" ++ "\n" ++
 show e                              ++ "\n" ++
 "------------------------------------" ++ "\n" ++
 editSigma (sigma (str,e))              ++ "\n" ++
 "------------------------------------" ++ "\n" ++
-- editTaus (tcs (str,e))                 ++ "\n" ++  los tipos de los constructores se incorporaron a la signatura
-- "------------------------------------" ++ "\n" ++
 editPi  pi                             ++ "\n" ++
 "------------------------------------" ++ "\n" ++
 show t                              ++ "\n" ++
 "------------------------------------" ++ "\n"
 
--edición de secuencias de PP en formato TEPT
meditPP pps=  concat (map editPP pps) 
 

-- Edición de programa con forma de comando
 
editCom (pi,str,e,t)  =                
 editStrC (glPi pi) str                   ++ 
 editcom (glPi pi) e                        ++ "\n" 
 ++ "------------------------------------\n" 


----------------------------------------------------------------------------------------
-- EDICIÓN de test de tipos
----------------------------------------------------------------------------------------

editPPTest ((pi,str,e,t),txs) = editPP (pi,str,e,t) ++ 
                                (if isGl t then editCom (pi,str,e,t) ++ editTypeTest "gl" txs else editTypeTest "su" txs) 
                                
editTypeTest m txs =  "Test " ++ 
                       (if m=="gl" || m=="lo" then "global: " else "subestructural: ") ++
                       (if txs == [] then "CORRECTO\n" else "INCORRECTO: \n" ++ concat txs) 
 
-- Auxiliar: es tipo global
isGl (Q (Gl x) a) = True
isGl (Q Lo a) = True
isGl (Prod ts) = or (map isGl ts)
isGl (Fun t1 t2) = isGl t1 || isGl t2
isGl (List (Gl x) t) = True
isGl (List Lo t) = True
isGl (FO x a b) = True
isGl t = False 


----------------------------------------------------------------------------------------
-- EDICIÓN de test de tipos y protección
----------------------------------------------------------------------------------------

editProt sq sg = "\n\n" ++
 editSigma sq                           ++ "\n" ++
 "------------------------------------" ++ "\n" ++ 
 editSigma sg                           ++ "\n" ++
 "------------------------------------" ++ "\n" ++ 
 if txs==[] then "HAY PROTECCIÓN\n" 
            else ("HAY PROTECCIÓN para todos los updates excepto: \n" ++ concat txs)  
 where txs = protege sq sg
