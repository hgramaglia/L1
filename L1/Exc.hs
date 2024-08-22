

module Exc
 (
  Var, 
  Pat(VP,P),
  Qu(Un,Hi,Su,U_,Lo,L_,Gl,Pu),
  Tau(Q,Prod,Fun,List,FO,ApT),dom,im,qTau,
  Taus,editTaus,
  Sigma, editSigma,sigma,iop,dop,
  Exc(Var,O,Tup,Lam,App,If,Let,Case),editcom,
  Value(Vi,Vb,Vf,Va,VN,Vl),eqValue,
  Sust(sust),
  Delta,msust,editDelta,
  Pi,editPi,editPis,tau,fvPi,glPi,comaPip,
  Str,editStr,editStrC,editMem,editFun,value,showResult,comaStr
 )

where

import Aux
import Alg

--------------------------------------------------------------------------
-- Variables, Patrones ---------------------------------------------------

type Var         = String

data Pat         = VP Var  | P [Pat]
 deriving (Eq)
instance Show Pat where 
 show (VP x) = x
 show (P ps) = "(" ++ editss (map show ps) ++ ")"
instance Ord Pat where
-- Pat implementa a Pat del artículo haciendo P [] = Lo
 (<=) (P []) (VP x) = True
 (<=) (VP z) (VP x) = (x==z)
 (<=) (P ps) (P ps') = length ps == length ps' && and (map (\(p,p') -> (<=) p p') (zip ps ps'))
instance FV Pat where
 fv (VP x) = [x]
 fv (P ps) = union (map fv ps)
 
-------------------------------------------------------------------------
-- L-types --------------------------------------------------------------

data Qu  = Un  | Hi | Su | Pu |  U_ | Lo | L_ | Gl Exc 
 deriving (Eq)
-- U_ representación interna de un! (se fija en subestructuralización)    
-- L_ representación interna de lo! (se fija en globalización)    

instance Show Qu where
 show Su  = "su"
 show Hi  = "hi"
 show Un  = "un"
 show U_  = "un!"
 show Lo  = "lo"
 show L_  = "lo!"
 show Pu  = "pu"  
 show (Gl (Var x)) = x
 
 -- Tipado Subestructural: Orden representa posibilidades de uso (se testea en tipos no en pseudotipos)
instance Ord Qu where
  (<=) Su q  = True
  (<=) Un Un = True
-- Tipado Global: Orden representa cantidad de información
  (<=) Lo q'          = True
  (<=) (Gl e) (Gl e') = e==e'
-- resto de los casos
  (<=) q q'           = if q == q' then True else False
  

data Tau = Q Qu String 
         | Prod [Tau]   -- no se alojan en memoria
         | Fun Tau Tau  -- son siempre irrestrictas
         | List Qu Tau  
         | FO Pat Tau Tau -- forall, aplicación para tipado global
         | ApT Tau Exc
 deriving (Eq)

instance Show Tau where  
 show (Q q s) = show q ++ " " ++ s
 show (Prod lts) = "(" ++ editProd lts ++ ")"
                      where editProd [] = ""
                            editProd  [lt] =  show lt 
                            editProd  (lt:lts) = show lt ++ "," ++ editProd lts
 show (Fun lt lt') =  show lt ++ "-> " ++ show lt'
 show (List q t) =  show q ++ " " ++ "[" ++ show t ++ "]"
 show (FO p t t') =  "\\" ++ show p ++ ":" ++  show t ++ "." ++  show t' 
 show (ApT t e) =  "(" ++ show t ++ ")[ " ++  show e ++ "]"

instance FV Tau where  
 fv (Q (Gl e) s) = fv e
 fv (Q q s) = []
 fv (Prod lts) = union (map fv lts) 
 fv (Fun lt1 lt2) = union [fv lt1,fv lt2] 
 fv (List (Gl e) t) = union [fv e,fv t]
 fv (List q t) = fv t
 fv (FO p t t1) = union [fv t,quitar (fv t1) (fv p)] -- union [quitar (fv t) (fv p),quitar (fv t1) (fv p)]  --   
 fv (ApT a b) = union [fv a,fv b]

instance Ord Tau where
 (<=) (List q t) (List q' t') =  q <= q' && t <= t' 
 (<=) (Q q s) (Q q' s') = q <= q' && s==s'
 (<=) (Prod ts) (Prod ts') = and (map (\(t,t') -> t <= t') (zip ts ts'))
 (<=) t t' = t==t'

dom (Fun t0 t1) = t0
dom (FO p t0 t1) = t0
dom _ = error ("dom: no tiene tipo funcional")

im (Fun lt0 lt1) = lt1
im (FO p t0 t1) = t1
im (Q q s) = error ("im: no tiene tipo funcional: es tipo básico")
im t = error ("im: no tiene tipo funcional: " ++ show t)

qTau :: Tau -> Qu
qTau (Q q a) = q
qTau (List q t) = q
qTau (Fun t1 t2) = Un
qTau (FO x t t') = Un
qTau (Prod ts) = error ("qTau: el tipo producto no tiene calificación: " ++ show (Prod ts))
qTau (ApT t e) = error ("qTau: el tipo \"aplicación\" no tiene calificación: " ++ show (ApT t e))

-- Secuencias de tipos 

type Taus = [Tau]

editTaus []  = []
editTaus  [t] =  show t 
editTaus (t:ts) = show t ++ ", " ++ editTaus ts

-----------------------------------------------------------------------------
-- Signatura ----------------------------------------------------------------

type Sigma = [(Sig,Tau)]

editSigma []      = []
editSigma [(o,t)] =  formatear 3 (codop o) ++ " : " ++ show t 
editSigma ((o,t):sig)  =  formatear 3 (codop o) ++ " : " ++ show t ++ ",\n" ++ editSigma sig

-----------------------------------------------------------------------------
-- Signatura de un programa

sigma (str,e) = sigstr str ++ sigexc e

sigexc (Var x) = []
sigexc (O (o,t) [e,e']) = case  stOp o of
                           0  -> (o,t) : concat (map sigexc [e,e']) 
                           1  -> sigexc e ++ [(o,t)] ++ sigexc e'
sigexc (O (o,t) [e,e',e'']) = case  stOp o of 
                               0 -> (o,t) : concat (map sigexc [e,e',e'']) 
                               1 -> sigexc e ++ [(o,t)] ++ sigexc e' ++ sigexc e''
                               2 -> sigexc e ++ sigexc e' ++ [(o,t)] ++ sigexc e''
sigexc (O (o,t) es) = (o,t) : concat (map sigexc es)
sigexc (Tup es) = concat (map sigexc es)
sigexc (App e e') =  sigexc e'
sigexc (If e a0 a1) = sigexc e ++ sigexc a0 ++ sigexc a1
sigexc (Let p a0 a1) = (sigexc a0) ++ (sigexc a1)
sigexc (Case q e a0 p a1) = (sigexc e) ++ (sigexc a0) ++ (sigexc a1)

sigstr str = concat (map (sigval.snd) str)

sigval (Vi i) = []
sigval (Vb i) = []
sigval (Vf p e) = sigexc e
sigval (Va a) = []
sigval (Vl x xs) = []


-- FUNCIONES PARA TIPOS DE OPERADORES DE SIGMA

dop (Q q s) = []
dop (List q s) = []
dop (Fun (Q q s) i) = [(Q q s)]
dop (Fun (List q s) i) = [(List q s)]
dop (Fun (Prod ds) i) = ds
dop t = error ("dop: no es tipo de operador k-ario: " ++ show t)
                                         
iop (Q q s) = Q q s
iop (List q s) = List q s
iop (Fun d i) = i
iop t  = error ("iop: no es tipo de un operador: " ++  show t)

-----------------------------------------------------------------------------
-- Expresiones del lenguaje (con operadores calificados)

data Exc =   Var Var 
         |   O (Sig,Tau) [Exc]   
         |   Tup [Exc]               
         |   Lam Pat Exc
         |   App Var Exc              
         |   If Exc Exc Exc
         |   Let Pat Exc Exc
         |   Case Qu Exc Exc Pat Exc
 deriving (Eq)

instance Show Exc where
 show (Var x) = x
 show (O (o,t) es) = editOp [] o (map show es)
 show (Tup []) = "()"
 show (Tup es) = "(" ++ editss (map show es) ++ ")"
 show (App f e') =  f ++ " (" ++ show e' ++ ")"
 show (Lam p e) = "(" ++ "\\" ++ show p ++  " . "  ++ show e ++ ")"
 show (Let p e e') = "(let " ++  show p ++  " = "  ++ show e ++ " in " ++ show e'++ ")"
 show (If e e' e'') = "if " ++ show e ++ " then " ++ show e' ++ " else " ++ show e''
 show (Case q e e' (P [VP x,VP xs]) e'') = 
  "(case " ++ show q ++ " " ++ show e ++ " of (" ++ show e' ++ ",(" ++ x ++ ":" ++ xs ++ ")->" ++ show e''++ "))"

instance FV Exc where
 fv (Var x) = [x]
 fv (O (o,t) es) = union (map fv es) -- union (fv t : map fv es)
 fv (Tup es) = union (map fv es)
 fv (Lam p a0) =  quitar (fv a0) (fv p)
 fv (App f e') =  f : fv e'
 fv (If e a0 a1) = union [fv e, fv a0, fv a1] 
 fv (Let p a0 a1) =  union [(fv a0) , (quitar (fv a1) (fv p))]
 fv (Case q e a0 p a1) =  union [fv e,fv a0,quitar (fv a1) (fv p)]

-------------------------------------------------------------------------------------------------
-- Edición de comando: pone asignación (operador con tipo Q (Gl x) s) y elimina var. de patrones

editcom xs (Var x) = x
editcom xs  (O (o,t) es) = editOpc x o (map (editcom xs) es)
 where x = case (qTau (iop t)) of
             Gl (Var x) -> x
             _          -> []
editcom xs (Tup []) = "()"
editcom xs (Tup es) = "(" ++ editss (map (editcom xs) es) ++ ")"
editcom xs (App f e') =  f ++ " (" ++ editcom xs e' ++ ")"
editcom xs (Lam p e) = "(" ++ "\\" ++ show p' ++  " . "  ++ editcom xs e ++ ")"
                             where p' = localpat p xs
editcom xs (Let p e e') = "(let " ++  show p' ++  " = "  ++ editcom xs e ++ " in " ++ editcom xs e'++ ")"
                            where  p' = localpat p xs
editcom xs (If e e' e'') = "(if " ++ editcom xs e ++ " then " ++ editcom xs e' ++ " else " ++ editcom xs e''++ ")"
editcom xs (Case q e e' p e'') = 
 "(case " ++ editcom xs e ++ " of (" ++ editcom xs e' ++ "," ++ localcase p xs ++ "->" ++ editcom xs e''++ "))"
  where localcase (P [VP z,VP zs]) xs = "("++z++":"++zs++")" {-case (esta z xs,esta zs xs) of
                                         (False,False)  -> "("++z++":"++zs++")"
                                         (True,False)   -> "(():"++zs++")"

                                         (False,True)   -> "("++z++":())"
                                         (True,True)  -> "(():())" -}

-- auxiliar de edición de comandos
localpat (VP r) xs = if esta r xs then P [] else VP r
localpat (P []) xs = P [] 
localpat (P ps) xs = P (map (\q -> localpat q xs) ps)

---------------------------------------------------------------------------------
-- Values -----------------------------------------------------------------------

data Value = Vb Bool | Vi Int | Va Array | Vf Pat Exc | VN | Vl Var Var 
 deriving (Eq)

instance Show Value where
 show  (Vi x) = show x
 show  (Vb True) = "true"
 show  (Vb False) = "false"
 show  (Va a) =  showArray a
 show  (VN)   =  "[]"
 show  (Vl x xs) =  "(" ++ x ++  ":"  ++ xs ++ ")"
 show  (Vf p' e) =  "(" ++ "\\" ++ show p' ++  " . "  ++ show  e ++ ")"

eqValue str (Vb v) str' (Vb v') = v == v'
eqValue str (Vi v) str' (Vi v') = v == v'
eqValue str (Va a) str' (Va a') = a == a'
eqValue str (VN) str' (VN)      = True
eqValue str (Vl x xs) str' (Vl x' xs') = eqValue str (value str x) str' (value str' x') && eqValue str (value str xs) str' (value str' xs')
eqValue str (Vf p e) str' (Vf p' e') = (Lam p e)==(Lam p' e')
eqValue str _ str' _ = False


---------------------------------------------------------------------------------
-- SUSTITUCIÓN ------------------------------------------------------------------
--------------------------------------------------------------------------
type Delta = [(Var,Exc)]

delta :: Delta -> Var -> Exc
delta [] x         = Var x
delta ((y,z):d) x  = if x==y then z else delta d x

editDelta [] = []
editDelta ((y,z):[]) = y ++ "->" ++ show z ++ " | "
editDelta ((y,z):d) = y ++ "->" ++ show z ++ "," ++ editDelta d

--------------------------------------------------------------------------
-- Mapa sustitución ------------------------------------------------------
-- Para ejecución

msust xs (P []) e = []
msust xs (VP x) e = if esta x xs then [] else [(x,e)]
msust xs (P ps) (Tup es) = concat (map (\(p,e) -> msust xs p e) (zip ps es))
msust xs p e = error ("msust: no se puede construir el mapa sustitución: " ++ show p ++ "  " ++ show e)

--------------------------------------------------------------------------
-- Sustitución : definición ----------------------------------------------

class Sust a where
 sust :: Delta -> a -> a

instance Sust Qu where
 sust d (Gl x) = case sust d x of
                   Var w  -> Gl (Var w)
                   _      -> Lo
 sust d q      = q

instance Sust Tau where
 sust d (Q Lo a) = Q Lo a  -- HAY QUE VOLVER A REVISR TODO
 sust d (Q q a) = Q (sust d q) a
 sust d (List Lo t) = List Lo (sust d t)
 sust d (List q t) = List (sust d q) (sust d t)
 sust d (Prod ts) = Prod (map (sust d) ts)
 sust d (Fun t1 t2) = Fun (sust d t1) (sust d t2)
 sust d t = error ("sust: no definido en " ++ show t)

instance Sust Pat where
 sust d (VP x)  = case delta d x of
                     Var y  -> VP y
                     e      -> error ("Pat.sust: a la variable " ++ x  ++ " de un patrón se la quiere sustituir por " ++ show e)
 sust d (P ps) = P (map (sust d) ps)

instance Sust Exc where
 sust d (Var x)  = delta d x
 sust d (O (o,t) es) =  O (o,(sust d t)) (map (sust d) es)
 sust d (Tup es) = Tup (map (sust d) es)
 sust d (App f e') = App f (sust d e')
 sust d (If e e' e'') = If (sust d e) (sust d e') (sust d e'')
 sust d (Lam p e) = Lam p' (sust d' e)
                     where d' = componer d dren
                           p'  = sust dren p
                           dren = map (\x -> (x,Var (fresh x cap))) (fv p)
                           cap =  filterVar (map (delta d) (quitar (fv e) (fv p)))
 sust d (Let p e e') = Let p' (sust d e)  (sust d' e')
                     where d' = componer d dren
                           p'  = sust dren p
                           dren = map (\x -> (x,Var (fresh x cap))) (fv p)
                           cap =  filterVar (map (delta d) (quitar (fv e') (fv p)))
 sust d (Case q e e' p e'') = Case (sust d q) (sust d e) (sust d e') p (sust d e'')
 sust d e = error ("Exc.sust")

--------------------------------------------------------------------------
-- Auxiliares ------------------------------------------------------------

-- composición de sustituciones 
componer d [] = d
componer d ((y,e):d') = componer ((filter f d)++[(y,e)]) d' 
				where f (x,e') = not (x==y)

-- elección de variable fresca que reemplace a x 
fresh x cap = primado x cap
  where primado x cap = if not (esta x cap) then x else primado (x++"'") cap

-- siempre se sustituye por variables, no tiene efecto
filterVar [] = []
filterVar (Var x : es) = x : filterVar es
filterVar (e : es) =  filterVar es

---------------------------------------------------------------------------------
-- Contextos de tipos -----------------------------------------------------------

type Pi = [(Var,Tau)]

editPi [] = []
editPi [(x,t)] = x ++ " : " ++ show t
editPi ((x,t):pi) = x ++ " : " ++ show t ++ ",\n" ++ editPi pi

editPis []  = []
editPis [pi] =  "[" ++ editPi pi ++ "]"
editPis (pi:pis) =  "[" ++ editPi pi ++ "]\n\n" ++ editPis pis


-- Entorno modificado por patrón
comaPip pi p t = limpiar pi (fv p) ++ flat (p,t)
 where limpiar pi xs = filter (\(x,t) -> not (esta x xs)) pi

-- todas las globales 
glPi [] = []
glPi ((x,Q (Gl (Var y)) s):pi) = if x == y then x : glPi pi else error ("Exc:glPi: " ++ editPi [(x,Q (Gl (Var y)) s)]) 
glPi ((x,List (Gl (Var y)) t):pi) =  if x == y then x : glPi pi else error ("Exc:glPi: " ++ editPi [(x,List (Gl (Var y)) t)]) 
glPi ((x,t):pi) = glPi pi

--------------------------------------------------------------------------
-- Valor de un contexto en una variable  -----------------------

tau :: Pi -> Var -> Tau
tau [] x =   error ("tau: no esta en el entorno: " ++ x) 
tau [] x      =   error ("tau: no esta en el entorno: pattern" ) 
tau ((x,lt):pi) y = if x==y then lt else tau pi y

fvPi pi = map fst pi

------------------
--Auxiliares Pi
------------------
flat (VP x,lt) = [(x,lt)]
flat (P [],lt) = []
flat (P ps,Prod lts) = concat (map flat (zip ps lts))
flat (VP x,Fun lt lt') = [(x,Fun lt lt')]
flat (VP x,List q lt) = [(x,List q lt)]
flat (p,t) = error ("flat: " ++ show p ++ "   " ++ show t)
--------------------------------------------------------------------------
-- Stores ----------------------------------------------------------------

type Str  = [(Var, Value)]

editStr [] = []
editStr [(x,v)] =  x ++ " = " ++ show v
editStr ((x,v):str) =  x ++ " = " ++ show v ++ ",\n" ++ editStr str



-- Edit Funciones ---------------------------------------------------------

editFun [] = []
editFun ((x,Vf p e):[])   = x ++ " = " ++ show (Vf p e) 
editFun ((x,v):[])   =  [] 
editFun ((x,Vf p e):str)  = x ++ " = " ++ show (Vf p e) ++ ", " ++ editFun str
editFun ((x,v):str)   =  editFun str 

-- Edicion de memoria  ----------------------------------------------------

editMem ::  Str -> String
editMem [] = []
editMem ((x,Vf p e):[])   = []
editMem ((x,Vb b):[])   = [] 
editMem ((x,v):[])          = x ++ " = " ++ show v 
editMem ((x,Vf p e):str)  = editMem str
editMem ((x,Vb b):str)  = editMem str
editMem ((x,v):str)   = x ++ " = " ++ show v ++ ", " ++ editMem str 

-- Edicion de stores en comandos ----------------------------------------

editStrC xs [] = []
editStrC xs ((x,Vb b):str) =  x ++ " = " ++ show (Vb b) ++ ",\n" ++ editStrC xs str
editStrC xs ((x,Vi b):str) =  x ++ " = " ++ show (Vi b) ++ ",\n" ++ editStrC xs str
editStrC xs ((x,Va b):str) =  x ++ " = " ++ show (Va b) ++ ",\n" ++ editStrC xs str
editStrC xs ((x,VN):str)   =  x ++ " = " ++ show (VN) ++ ",\n" ++ editStrC xs str
editStrC xs ((x,Vl a b):str) =  x ++ " = " ++ show (Vl a b) ++ ",\n" ++ editStrC xs str
editStrC xs ((x,Vf p e):str) =  x ++ " = " ++  "(" ++ "\\" ++ show (localpat p xs) ++  " . "  
                                  ++ editcom xs e ++ ")" ++ ",\n" ++ editStrC xs str
-- mostrar resultado

showResult str (Var x) =
 case value str x of
   (Vl z zs) -> x ++ "=[" ++ showL str (Vl z zs) ++ "]"
                    where showL str VN = []
                          showL str (Vl z zs) =  if ls==[] then show (value str z) else show (value str z) ++ "," ++ ls  
                                                     where ls = showL str (value str zs)
   (VN)      -> x ++ "=[]"
   v         -> x ++ "=" ++  show v

showResult str (Tup es) = "(" ++ mshowResult str es ++ ")"
                          where mshowResult str [] = []
                                mshowResult str [v] = showResult str v                 
                                mshowResult str (v:vs) = showResult str v ++ "," ++ mshowResult str vs                 


-- operadores coma: str,x->v

comaStr str [] = str
comaStr str ((y,v):str') = comaStr ((filter f str)++[(y,v)]) str' 
				where f (x,v) = not (x==y)

eliminar [] r = error ("eliminar una var del enviroment: no existe la var " ++ r)
eliminar ((x,v):str) r =  if x==r then str else (x,v) : eliminar str r
 
--------------------------------------------------------------------------
-- Valor de un environment en una variable  ------------------------------

value :: Str -> Var -> Value

value [] x         =  error ("value: la variable "++x++" no está en el ambiente") 
value ((y,v):str) x = if x==y then v else value str x

