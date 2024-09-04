
module Type
 (
  test,protege,tkTau,spl,sspl,editsplit -- test de linealidad y globalidad, test de protección
 )

where

import Aux
import Alg
import Exc
import Sig

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- AUXILIARES PARA TIPADO WEAK-LINEAL
------------------------------------------------------------------------------------------

-- INVARIANTE SUBESTRUCTURAL
-- okTau q T = q(T) donde q(T) sii T = q' t con q <= q'
-- se utiliza okTau Un _ para testear irrestricto
okTau Un (Q q s) = if q==Su then ["test de invariante: el tipo " ++ show (Q q s) ++ " no es irrestricto\n"]
                                   else []
okTau Un (Prod ts) = ["test de invariante: tipo producto " ++ show (Prod ts)++ "\n"]  -- el tipo producto no aparece en el store
okTau Un (Fun t t') = [] 
okTau Un (List Su t) = ["test de invariante: tipo lista " ++ show (List Su t)++ " no es irrestricta\n"]   
okTau Un (List q t) = []  
okTau Un (FO p t t') = []  
okTau Un (ApT t e) = []  
okTau q t = []
okTau Un t = error ("okTau: " ++ show t)

-- testeo de que un operador-constructor irrestricto no tenga componentes (constructoras) lineales
okOp (o,t) = 
  case o of
   ConOp   -> if concat (map (okTau q) (dop t)) == [] then []
              else  ["test de invariante: constructor con tipo ilegal " ++ show t ++ "\n"] 
                where q = qTau (iop t)
   DConOp  -> if concat (map (okTau q) (tail (dop t))) == [] then []
              else  ["test de invariante: constructor con tipo ilegal " ++ show t ++ "\n"] 
                where q = qTau (iop t)
   _     -> []

-- Testeo de invariante subestructural
okPi q pi = concat (map ((okTau q).snd) pi)

-- subcontexto irrestricto
doPiUn [] = []
doPiUn ((x,FO p t t'):pi) = (x,FO p t t') : doPiUn pi
doPiUn ((x,t):pi) = if Su==(qTau t) then doPiUn pi else (x,t) : doPiUn pi

------------------------------------------------------------------------------------------
-- PSEUDOSPLIT DE ENTORNOS
------------------------------------------------------------------------------------------

-- spl: secuencia de tuplas (pi1,...,pin) tales que pi = pi1 * .... * pin, la única compatible
-- con una distribución de variables subestructurales representada en (xs1,...,xsn)

-- SE TRIVIALIZA si no hay calificadores su en el programa
-- spl 1 xss pi = [pi]
-- spl (k+1) xss pi = pi : spl k xss pi
-- sspl 1 xss pi = [pi]
-- sspl (k+1) xss pi = pi : sspl k xss pi

spl :: Int -> [[Var]] -> Pi -> [Pi]

spl 1 xss pi         = [pi]  
spl n xss []         = doenv n
                       where doenv 1 =  [[]]
                             doenv n = [] : doenv (n-1)
spl n xss ((x,t):pi) = 
 case t of 
  (Q Su s)  -> ins (x,Q Su s) (lugar x xss) (spl n xss pi)
  List Su t -> ins (x,List Su t) (lugar x xss) (spl n xss pi)
  _         -> map ((:) (x,t)) (spl n xss pi)
 where
  lugar x []   = error "lugar en spl: 0 partes"
  lugar x [xs] = if esta x xs then 1 else 0  -- lugar en donde ocurre x la primera vez
  lugar x (xs:xss) = if k == 0 then (if esta x xs then 1 else 0) 
                               else k+1 --(if esta x xs then error ("Type/spl (split strong): no se puede " ++ 
                                        --                       "realizar por múltiple ocurrencia de " ++x)) 
                                        --          else k+1) 
                      where k = lugar x xss 
  ins p 0 [] = error "spl: ins"
  ins p 0 (pi:pis) = (p:pi):pis
  ins (x,Q Su s) 1 (pi:pis) = ((x,Q Su s):pi):pis
  ins (x,Q Su s) k (pi:pis) = ((x,Q Hi s):pi) : ins (x,Q Su s) (k-1) pis
  ins (x,List Su t) 1 (pi:pis) = ((x,List Su t):pi):pis
  ins (x,List Su t) k (pi:pis) = ((x,List Hi t):pi) : ins (x,List Su t) (k-1) pis
  ins _ _ _ = error "ins en spl: no se insertan salvo su"

------------------------------------------------------------------------------------------
-- SPLIT DE ENTORNOS (STRONG)
------------------------------------------------------------------------------------------

sspl :: Int -> [[Var]] -> Pi -> [Pi]

sspl 1 xss pi         = [pi]  
sspl n xss []         = doenv n
                       where doenv 1 =  [[]]
                             doenv n = [] : doenv (n-1)
sspl n xss ((x,t):pi) = 
 case t of 
  Q Su s      -> ins (x,Q Su s) (lugar x xss) (sspl n xss pi)
--  Fun t t' -> ins (x,Fun t t') (lugar x xss) (sspl n xss pi)
  List Su t  -> ins (x,List Su t) (lugar x xss) (sspl n xss pi)
  _           -> map ((:) (x,t)) (spl n xss pi)
 where
  lugar x []   = error "lugar en spl: 0 partes"
  lugar x [xs] = if esta x xs then 1 else 0  -- lugar en donde ocurre x la primera vez
  lugar x (xs:xss) = if k == 0 then (if esta x xs then 1 else 0) else k+1 
                      where k = lugar x xss 
  ins p 0 [] = error "spl: ins"
  ins p 0 (pi:pis) = (p:pi):pis
  ins (x,Q Su s) 1 (pi:pis) = ((x,Q Su s):pi):pis
  ins (x,Q Su s) k (pi:pis) = pi : ins (x,Q Su s) (k-1) pis
  ins (x,List Su t) 1 (pi:pis) = ((x,List Su t):pi):pis
  ins (x,List Su t) k (pi:pis) = pi : ins (x,List Su t) (k-1) pis
  ins _ _ _ = error "ins en spl: no se insertan salvo su"


--------------------------------------------------------------------------
-- Edición de split

editsplit [] = []
editsplit (pis : piss) = editseq pis ++ "\n" ++ editsplit piss
   where  editseq  []           = []
          editseq [pi] =  "[" ++ editPi pi ++ "]"
          editseq  (pi:pis) =  "[" ++ editPi pi ++ "] " ++ editseq pis


--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- AUXILIARES PARA TIPADO GLOBAL
-------------------------------------------------------------------------
 
-- (<=) multiple
mleq ts ts' = and (map (\(t,t') -> t <= t') (zip ts ts'))

---------------------------------------------------------------------------------
-- Obtener el tipo de un expresión 

tkTau pi (Var x) =  if esta x (map fst pi) then tau pi x else error ("Exc/tkTau: la variable " ++ x ++ " no esta en:\n" ++ editPi pi )
tkTau pi (O (o,t) es) =  iop t
tkTau pi (Tup es)  =  Prod (map (tkTau pi) es) 
tkTau pi (If e e' e'') = if (tkTau pi e')==(tkTau pi e') then (tkTau pi e') 
                         else error ("Exc tkTau en if: tipos no coincidentes:\n" ++ 
                                       show (tkTau pi e') ++ "  " ++ show (tkTau pi e'') )     
tkTau pi (Let p e e')  = sust dta (tkTau (comaPip pi p lt0) e') 
                          where lt0 = tkTau pi e
                                dta = msust (glPi pi) p (glExcTau lt0) 
tkTau pi (App f e) = case tau pi f of
                        FO p t t' -> sust dta t'  where dta = msust (glPi pi) p (mapp pi e) 
                        Fun t t'  -> t'
                        a         -> error ("Exc tkTau: " ++ f ++ " no es función: " ++ show a)
tkTau pi (Case q e e' p e'')  = case tkTau pi e of
                                 List q t   -> tkTau (comaPip pi p (Prod [t,List q t])) e' 
                                 _          -> error ("Exc tkTau en case: el tipo no es lista " ++ show (tkTau pi e) ) 

-- obtener el tipo mas informativo
tkTauf pi (Var x) =  if esta x (map fst pi) then case tau pi x of
                                                  Q q s     -> Q (Gl (Var x)) s
                                                  List q s  -> List (Gl (Var x)) s
                                                  t         -> t 
                     else error ("Exc/tkTauf: la variable " ++ x ++ " no esta en:\n" ++ editPi pi )
tkTauf pi (O (o,t) es) =  iop t
tkTauf pi (Tup es)  =  Prod (map (tkTauf pi) es) 
tkTauf pi (If e e' e'') = if (tkTauf pi e')==(tkTauf pi e') then (tkTauf pi e') 
                         else error ("Exc tkTauf en if: tipos no coincidentes:\n" ++ show (tkTauf pi e') ++ "  " ++ show (tkTauf pi e'') )     
tkTauf pi (Let p e e') = sust dta (tkTauf (comaPip pi p lt0) e')  
                          where lt0 = tkTauf pi e
                                dta = msust (glPi pi) p (glExcTau lt0) 
tkTauf pi (App f e) = case tau pi f of
                       FO p t t' -> sust dta t'  where dta = msust (glPi pi) p (glExcTau (tkTauf pi e))  
                       Fun t t'  -> t'
                       a         -> error ("Exc tkTauf: " ++ f ++ " no es función: " ++ show a)
tkTauf pi (Case q e e' p e'')   = case tkTauf pi e of
                                 List q t   -> tkTauf (comaPip pi  p (Prod [t,List q t])) e' 
                                 _          -> error ("Exc tkTauf en case: el tipo no es lista " ++ show (tkTauf pi e) ) 


-- tkTau múltiple
mtkTau pi es = map (tkTau pi) es 
mtkTauf pi es = map (tkTauf pi) es 


-- mapa T -> p_T del artículo pero devuelve el patrón con fomormato de expresión, lo = ()
glExcTau (Q (Gl (Var x)) a) = Var x
glExcTau (Q q a) = Tup []
glExcTau (List (Gl (Var x)) a) = Var x
glExcTau (List q a) = Tup []
glExcTau (Prod ts) = Tup (map glExcTau ts)
glExcTau (Fun t1 t2) = Tup []
glExcTau (FO p t t') = Tup []
glExcTau t = error ("Exc:glExcTau: " ++ show t)

-- mapa p^\Gamma e
-- para usar mapa sustitución devuelve exprsión en lugar de patrón
mapp pi (Var x) =  Var x
mapp pi (O (o,t) es) = glExcTau (iop t)
mapp pi (Tup es)  =  Tup (map (mapp pi) es) 
mapp pi (If e e' e'') = if (mapp pi e')==(mapp pi e'') then (mapp pi e') 
                         else error ("Exc:mapp en if: exc. no coincidentes:\n" ++ show (mapp pi e') 
                                      ++ "  " ++ show (mapp pi e'') )     
mapp pi (Let p e e') =  mapp pi (sust dta e')  where dta = msust (glPi pi) p (mapp pi e) 
mapp pi (App f e) = case tau pi f of
                       FO p t t' -> glExcTau (sust dta t')  where dta = msust (glPi pi) p (mapp pi e)  
                       Fun t t'  -> glExcTau t'
                       a         -> error ("Exc mapp: " ++ f ++ " no es función: " ++ show a)
mapp pi (Case q e e' p e'')  = case tkTau pi e of
                                 List q t -> if (mapp pi e')==(mapp ( comaPip pi p (Prod [t,List q t])) e'')
                                             then (mapp pi e')
                                             else error ("Exc:mapp en case: exc. no coincidentes:\n" ++ show (mapp pi e') ++ "  " ++ 
                                                             show (mapp (comaPip pi p (Prod [t,List q t])) e''))  
                                 _          -> error ("Exc:mapp en case: el tipo no es lista " ++ show (tkTau pi e) )
                                  
mmapp pi es = map (mapp pi) es 

------------------------------------------------------------------------------------------
-- TEST DE TIPOS UNIFICADO - SUBESTRUCTURAL - GLOBAL - UPDATE IN PLACE (TIPOS DEPENDIENTES)
------------------------------------------------------------------------------------------
-- Las funciones devuelven secuencias de string
-- [] = True

test pi (str,e) t = tStr str pi ++ tExc pi e t

--Tipado de tuplas
mtExc [] [] [] = []
mtExc (pi:pis) (e:es) (t:ts) = (tExc pi e t) ++ (mtExc pis es ts)
mtExc pis es ts = ["mtExc: distintas long. de secuencias\n"]



tExc :: Pi -> Exc -> Tau -> [String]

 
tExc pi (Var x) t = if esta x (map fst pi) then 
                           if t==tx then (if null pi'  then []
                                                  else ["en el contexto\n" ++ editPi pi ++ "\n hay otra variable "
                                                         ++ " subestructural (se pretende tipar " ++ x ++  ")\n"])
                           else if tx <= t && (qTau t)==(Gl (Var x)) then []
                                else 
                                       ["en el contexto\n" ++ editPi pi ++ "\nla variable " 
                                        ++ x ++ " no tiene tipo el tipo solicitado "++ show t ++
                                         ", y tampoco este es instancia protegida\n"]
                    else ["la variable " ++ x ++ " no esta en el contexto " ++  editPi pi ++ "\n"]
  where
    tx  = tau pi x  
    pi' = filter (isOtherSu x) pi
    isOtherSu y (x,t)  = if x == y then False else   
                          case t of
                           Q Su s     -> True
                           List Su t  -> True
                           _          -> False                  

tExc pi e (Q Hi s) = ["expresión no variable " ++ show e ++ " no puede tener tipo oculto\n"] 

tExc pi (O (o,t) es) t0 = 
 if (iop t)==t0 then
 if okOp (o,t) ==[] then 
  case length (dop t) of
   0     -> if okPi Un pi == [] then []
            else ["operador " ++ codop o ++ ": el contexto no es irrestricto:\n " ++ editPi pi ++ "\n"]    
   k     -> if mleq (dop t) ts then mtExc pis es ts  -- if  o==ConOp then error (editTaus (ts++[t])) else mtExc pis es ts 
                               else ["operador " ++ show (O (o,t) es) ++ " con input de tipo incorrecto:\ntipo calculado: " 
                                      ++ editTaus ts ++ "\ntipo del operador: "++ show (dop t) ++ "\n"] 
             where pis = if o==ConOp || o==ConOp then spl k (map fv es) pi else sspl k (map fv es) pi
 else okOp (o,t)
 else [codop o ++ ": el tipo de output esperado -" ++ show t0 ++  
       "- no coincide con el del operador: " ++ show  (iop t) ++ "\n" ++ show (O (o,t) es) ++ "\n"]
 where ts  = case qTau (iop t) of             
                   Gl vx -> mtkTauf pi es
                   Lo    -> mtkTauf pi es   -- con mtkTau se quita posibilidades de tipado (ver abajo)
                   L_    -> mtkTauf pi es   
                   _     -> mtkTau  pi es

-- con mtkTau se tipa incorrectamentetiene (==0) x, con (==0) : x int->lo bool (pi x = lo int) (ver fact3, fib1, etc.)
-- con esta modificación muygl.gl lograría tipar con el algoritmo (todo local)
-- IMPLEMENTACIÓN: se usa tkTauf pi e = (mapp pi e) . (tkTau pi e)  (viendo mapp pi e como patrón)


tExc pi (O (o,t) es) lt = ["operador " ++ codop o ++ ": los tipos no son válidos para un operador\n"]

tExc pi (Tup []) t = []

tExc pi (Tup es) (Prod ts) =  if length ts == length es 
                              then if f (head es) then error (editPi pi ++ "\n\n" ++ editseq (spl (length ts) (map fv es) pi))
                                                  else  mtExc (spl (length ts) (map fv es) pi) es ts
                              else ["tupla: las longitudes tupla y tipo no coinciden\n"]
 where
  f (O (UpdOp,t) es) = False
  f e = False
  editseq  []           = []
  editseq [pi] =  "[" ++ editPi pi ++ "]"
  editseq  (pi:pis) =  "[" ++ editPi pi ++ "] " ++ editseq pis

tExc pi (If e e' e'') lt =  --error (editPi (head (tail pis)))
                            mtExc pis [e,e',e''] [lt0,lt,lt] 
 where add (pi : (pi' : pis)) = pi : (pi' : (pi' : pis))
       lt0 = tkTau pi e
       pis = add (spl 2  [fv e,union [fv e',fv e'']] pi)
       editseq  []           = []
       editseq [pi] =  "[" ++ editPi pi ++ "]"
       editseq  (pi:pis) =  "[" ++ editPi pi ++ "] " ++ editseq pis


tExc pi (Let p e e' ) lt    = if lt==lt1 --  \p_{\T'} = p^\Gamma \e (lt=\T') 
                              then --if chinv1 pi2 p lt0 then  ESTE CHEQUEO SE HACE EN tExc pi e lt0
                                   stPat p lt0 ++ mtExc (f spls) [e,e'] [lt0,lt1]
                                   --else ["No se puede borrar globalidad con la localidad:\n" ++ 
                                   --       editPi (filter (\(x,t) -> esta x (fv p)) pi2) ++ "\n" ++ 
                                   --       show p  ++ "\n" ++ show lt0 ++ "\n"]
                              else [show (Let p e e') ++ "\n" ++
                                    "Tipo esperado: " ++  show lt ++ "\n" ++ 
                                    "Tipo calculado de " ++ show e' ++ ":  " ++  show lt1 ++ "\n"]
 where
  spls = spl 2 [fv e,quitar (fv e') (fv p)] pi
  pi2  = head (tail spls)
  f (pi1 : (pi2:pis)) = pi1 : (pi2' : pis)  where pi2' = comaPip pi2 p lt0
  lt0 = tkTau pi e      
  dta = msust (glPi pi) p (mapp pi e)      
  lt1 = sust dta lt
  editseq  []           = []
  editseq [pi] =  "[" ++ editPi pi ++ "]"
  editseq  (pi:pis) =  "[" ++ editPi pi ++ "] " ++ editseq pis

tExc pi (App f e) lt =   --if f=="f" then error (editPi pi) else
                         case tf of
                             Fun d i ->  if i==lt && d==td 
                                         then tExc pi e d
                                         else [f ++ " función y argumento compatibles: " ++ show tf ++ "\n" ++ 
                                               show e ++ " : " ++ show td ++ "\n" ++
                                               "Tipo del resultado : " ++ show lt ++ "\n"] 
                                                where  td  =  tkTau pi e
                             FO p d i -> if i'==lt &&  d <= td 
                                         -- si se pone d en lugar de tkTau entonces el paréntesis sobra
                                         then tExc pi e td
                                         else [show (App f e) ++ "\n" ++ f ++ 
                                                              " for all con output o input no compatible:\n" ++
                                                              "Tipo de la función en el contexto: " ++  show tf ++ "\n" ++ 
                                                              "Tipo esperado: " ++  show lt ++ "\n"++ 
                                                              "Tipo de la imagen: " ++ show i' ++ "\n" ++
                                                              "Tipo del dominio: " ++  show d ++ "\n" ++
                                                              "Tipo de la expresión: " ++  show td  ++"\n"]
                                           where dta =  msust (glPi pi) p (mapp pi e)  
                                                 i'  =  sust dta i
                                                 td  =  tkTau pi e
                                                                                          
                             _       ->  [f ++ " su tipo no es función ni for all\n"]
 where tf  =  tau pi f 

tExc pi (Case q e e' (P [VP z,VP zs]) e'' ) lt  =  --error (editPi (comaPip pi2 (P [VP z,VP zs]) lt1))
     if glp==[] then 
     mtExc (f spls) [e,e',e''] [lth,lt,lt]
     else ["Case con parámetro global: " ++ editss glp ++ "\n" ++ editPi (filter (\(x,t) -> esta x [z,zs]) pi2) ++ "\n"]
 where
  spls = spl 2 [fv e,union [fv e',quitar (fv e'') [z,zs]]] pi
  pi2  = head (tail spls)
  f (pi1 :(pi2:pis)) = pi1 : (pi2 : (pi2' : pis))  where pi2' = comaPip pi2 (P [VP z,VP zs]) lt1
  lth = tkTau (head spls) e
  lt0 = tkTau pi e
  lt1 = Prod [elType lt0,lt0]
  glp = filter (\x -> x==z||x==zs) (glPi pi)
  elType (List q t) = t
  elType t = error ("Exc elType: el tipo no es lista " ++ show t)

tExc pi (Case q e e' p e'' ) lt  = ["Case con patrón incorrecto"] 

         
tExc pi e t = error ("tExc: expresión y tipo no corresponde: " ++ show e ++ " : " ++ show t) 

----------------------------------------------------------------------------------------
-- Test de mapa sustitución para tipos (si cambia Gl x debe ser por Gl w)

tmsust xs [] = []
tmsust xs ((x,Var y) : dta) = tmsust xs dta
tmsust xs ((x,e) : dta) = if esta x xs 
                          then ["No se puede sustituir la referencia " ++ x ++ " por una refencia indefinida: " ++ show e ++ "\n"]
                          else tmsust xs dta


----------------------------------------------------------------------------------------
-- tipado de patrones

stPat p t = tExc (comaPip [] p t) (excPat p) t
 where excPat (VP x) = Var x
       excPat (P ps) = Tup (map excPat ps)
       
----------------------------------------------------------------------------------------
-- TIPADO DE STORE


-- |- x1->v1,...,xn->vn : x1:t1,...,xn:tn               si y sólo si 
-- tStr  [(x1,v1),...,(xn,vn)] [(x1,t1),...,(xn,tn)]   si y sólo si
-- tStr_ pi0 [(xn,vn),...,(x1,v1)] [(xn,tn),...,(x1,t1)]

tStr str pi = tStr_ (reverse pi) (reverse str) (reverse pi)

tStr_ pi0 [] [] = []
tStr_ pi0 ((x,Vi i) : str) ((y,Q q' "int") : pi) =  
  if x==y then tStr_ pi0 str pi else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 
tStr_ pi0 ((x,Vb b) : str) ((y,Q q' "bool") : pi) =  
  if x==y then tStr_ pi0 str pi else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 
tStr_ pi0 ((x,Va a) : str) ((y,Q q' "array") : pi) =  
  if x==y then tStr_ pi0 str pi else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 
tStr_ pi0 ((x,Vf p e) : str) ((y,Fun td ti) : pi) = 
 if x==y then tStr_ pi0 str pi ++ stValue (doPiUn pi) x (Vf p e) (Fun td ti)
         else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 
 where  -- testear función recursiva x = \p. ...x...
        stValue piun x (Vf p e) (Fun td ti) =  tExc (comaPip [] p td) (tkexc p) td ++
                                                    tExc (comaPip piun p td ++ [(x,Fun td ti)]) e ti  
        tkexc (VP x) = Var x
        tkexc (P ps) = Tup (map tkexc ps) 
tStr_ pi0 ((x,Vf p e) : str) ((y,FO p' td ti) : pi) = 
 if x==y then tStr_ pi0 str pi ++ stValue (doPiUn pi) x (Vf p e) (FO p' td ti)
         else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 
 where  
        stValue piun x (Vf p e) (FO p' td ti) =  --if x == "f" then error (show (Vf p e) ++ show (FO p' td ti) ) else 
                                                 if  p' <= p 
                                                 then tExc (comaPip [] p td) (tkexc p) td ++
                                                      tExc (comaPip piun p td ++ [(x,FO p' td ti)]) e ti 
                                                 else ["Type/stValue en tStr: valor función " ++ x ++ 
                                                          " y tipo con patrones incompatibles\n" 
                                                         ++ show p ++ "    " ++ show p' ++ "\n"]                           
        tkexc (VP x) = Var x
        tkexc (P ps) = Tup (map tkexc ps) 
  
                   
tStr_ pi0 ((x,v) : str) ((y,t) : pi) =  
  if x==y then ["tStr_: el valor\n" ++ show v ++ "\ny el tipo\n" ++ show t ++ " no responden a ningún patrón" ++ "\n"] 
          else ["tStr_: store y contexto no coordinados: " ++ x ++ " /= " ++ y ++ "\n"] 

tStr_ pi0 ((x,v) : str) [] =  ["tStr_: store y contexto de distinta longitud" ++ "\n"] 

tStr_ pi0 [] ((y,t) : pi) =  ["tStr_: store y contexto de distinta longitud" ++ "\n"]

---------------------------------------------------------------------------
-- PROTECCIÓN SUBESTRUCTURAL ----------------------------------------------
---------------------------------------------------------------------------


protege :: Sigma -> Sigma -> [[Char]]
protege ss sg = concat (map prS (zip ss sg))
 where prS ((o,t),(o',t')) = if o==o' then prTau o t t'
                             else ["Glo/prSigma: no hay correlación entre las signaturas: " ++ codop o ++ "   " ++ codop o' ++ "\n"]
 
 
prTau o ts tg = 
 case qTau (iop tg) of
  Gl (Var x) -> if k == length qgs then [formatear 30 (codop o ++ ": " ++ show ts)  ++ " no protege  " ++ codop o 
                                         ++ ": " ++ show tg ++ "\n"]
                else if (qss!!k)==Su && (qTau (iop ts))==Su then []
                     else [formatear 30 (codop o ++ ": " ++ show ts)  ++ " no protege  " ++ codop o  ++ ": " ++ show tg ++ "\n"]
                 where k = search x qgs
  _          -> []
 where 
  qss = map qTau (dop ts)
  qgs = map qTau (dop tg)
  search x [] = 0
  search x (Gl (Var y) : qs) = if x==y then 0 else 1 + search x qs
  search x (q : qs) = 1 + search x qs    







