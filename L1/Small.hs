

module Small
 (
  isCt, isVar,
  Modo(Irrestricto,Subestructural,Local,Global),
  Inf, editInf,
  Config, editConfig, cstr,cexc,cinf,cn,ck,
  correct, intconf, editRatioSu, editRatioGl, editRatioGlSu,   
  Ejec,
  red, partialRed,
  ssu, -- presupone un programa con calificadores de destrucción (un!,un,su)
  sgl, -- presupone un programa con calificadores de reescritura (lo!,lo,gl) 
  tamb -- tamaño de memoria
 )
where

import Aux
import Alg
import Exc
import Sig

-------------------------------------------------------------------
-- Formas canónicas -----------------------------------------------

isCt (Var x)   = True
isCt (Tup cts) = and (map isCt cts)
isCt e         = False 

isVar (Var x)    = True
isVar _          = False
 
var (Var x)      = x
var e            = error ("Small/var: " ++ show e ++ " no es variable")

-------------------------------------------------------------------------
-- CONFIGURACIONES ------------------------------------------------------
-------------------------------------------------------------------------

data Modo         = Irrestricto | Subestructural | Local | Global [Var] 


type Inf = (Int,Int,Int)

editInf (n0,n,k) = "Tamaño inicial de Memoria:         " ++ show n0 ++ "\n" ++
                   "Tamaño máximo de Memoria:          " ++ show n ++ "\n" ++
                   "COSTO TOTAL: "                       ++ show (n-n0)  ++ "\n" ++
                   "Cantidad de Pasajes de parámetros: " ++ show k ++ "\n" 

setMmax (n0,n,k) n'  = (n0,max n n',k)
setM (n0,n,k) n' = (n0,n+n',k)
setP (n0,n,k) k'  = (n0,n,k+k')
 
                              
type Config    =  (Str,Exc,Inf)   

editConfig m (str,e,inf) = 
 if isCt e then  
 case showResult str e of
  [] -> 
   "---------------------------------------------------------------------------------\n" ++
   editMem  str ++ "\n" ++
   "---------------------------------------------------------------------------------\n" ++
   show e ++ "\n" ++  
   "---------------------------------------------------------------------------------\n" ++
   editInf inf
  s  -> 
   "---------------------------------------------------------------------------------\n" ++
   editMem  str ++ "\n" ++
   "---------------------------------------------------------------------------------\n" ++
   show e ++ "\n" ++  
   "---------------------------------------------------------------------------------\n" ++
   s  ++ "\n" ++ 
   "---------------------------------------------------------------------------------\n" ++
   editInf inf
 else  
  "---------------------------------------------------------------------------------\n" ++
  editMem  str ++ "\n" ++
   "---------------------------------------------------------------------------------\n" ++
  show e ++ "\n" ++  
  "---------------------------------------------------------------------------------\n" ++
--   editTaus (tcsexc e)                 ++ "\n" ++
-- "----------------------------------------------------------------------------------" ++ "\n" ++   los constructores se incorporaron a la signatura
  editInf inf

-------------------------------------------------------------------
-- EJECUCIÓN ------------------------------------------------------
-------------------------------------------------------------------

type Ejec     = [Config]

cstr (str,e,inf) = str
cexc (str,e,inf) = e
cinf (str,e,inf) = inf

cn (str,e,(n0,n,k)) = n-n0
ck (str,e,(n0,n,k)) = k


red   :: Modo -> Config -> [Config]

red m (str, e , inf) = 
         if int e  then (str , Var interrupcion , inf) : []
         else
         case isCt e of 
           (True)  -> (str,e,inf) : []
           (False) -> case m of 
                        Irrestricto     -> (str,e,inf) : red m (ssu  (str,e,inf))
                        Subestructural  -> (str,e,inf) : red m (ssu  (str,e,inf))
                        (Global xs )    -> (str,e,inf) : red m (sgl xs  (str,e,inf))

partialRed   :: Int -> Modo -> Config -> [Config]
partialRed 0 m (str,e,inf)     = [(str, e ,inf)]
partialRed l m (str,e,inf) = 
      case isCt e of 
           (True)  -> (str,e,inf) : []
           (False) -> case m of 
                        Irrestricto    -> (str,e,inf) : partialRed (l-1) m (ssu  (str,e,inf))
                        Subestructural -> (str,e,inf) : partialRed (l-1) m (ssu  (str,e,inf))
                        Global   xs    -> (str,e,inf) : partialRed (l-1) m (sgl xs (str,e,inf))

---------------------------------------------------------------------------------
-- Terminación de la ejecución subestructural

interrupcion = "ejecución interrumpida"

intconf (str,e,inf) = int e

int (Var x ) = (x == interrupcion)
int (Tup es) = or (map int es) 
int (O (o,t) es) = or (map int es)
int (App f e) =  int e
int (If e a0 a1) = or (map int [e,a0,a1]) 
int (Let p a0 a1) =  or (map int [a0,a1])
int (Case q e  a0 p a1) =  or (map int [e,a0,a1])


---------------------------------------------------------------------------------
-- correccción de la ejecución global respecto del Irrestricto

correct (str,Var x,inf) (str',Var x',inf') = eqValue str (value str x) str' (value str' x') 
correct (str,Tup es,inf) (str',Tup es',inf') =  
         and (map (\(e,e') -> correct (str,e,inf) (str',e',inf')) (zip es es'))
correct (str,e,inf) (str',e',inf') = error ("correct: patrones no compatibles\n" ++ show e ++ "\n" ++ show e')

---------------------------------------------------------------------------------
-- Edición de ejecuciones comparadas

editRatioGl cpu c    = "Ratio mem: " ++ show (cn c) ++ "/" ++ show (cn cpu) ++ "    " ++
                       "Ratio pp:  " ++ show (ck c) ++ "/" ++ show (ck cpu) ++ "\n" ++
                       "La ejecución global " ++ 
                       (if correct cpu c then "es correcta" else "ES INCORRECTA") ++ "\n" ++
                       "------------------------------------" ++ "\n"

editRatioSu cpu c    = "Ratio mem: " ++ show (cn c) ++ "/" ++ show (cn cpu) ++ "    " ++
                       "Ratio pp:  " ++ show (ck c) ++ "/" ++ show (ck cpu) ++ "\n" ++
                       "La ejecución subestructural  " ++ 
                       (if intconf c then "SE INTERRUMPE" else "NO SE INTERRUMPE") ++ "\n" ++
                       "------------------------------------" ++ "\n"

editRatioGlSu cpu c c' = "Ratio mem: " ++ show (cn c) ++ "/" ++ show (cn cpu) ++ "    " ++
                           "Ratio pp:  " ++ show (ck c) ++ "/" ++ show (ck cpu) ++ "\n" ++
                           "La ejecución global " ++ 
                           (if correct cpu c then "es correcta" else "ES INCORRECTA") ++ "\n" ++
                           "La ejecución subestructural  " ++ 
                           (if intconf c' then "SE INTERRUMPE" else "NO SE INTERRUMPE") ++ "\n" ++
                           "------------------------------------" ++ "\n"

-------------------------------------------------------------------------------
-- test de continuación

ctest str [] = []
ctest str (x:xs) = if esta x (map fst str) then ctest str xs else x

-------------------------------------------------------------------------------
-- Small Step Semantic:  Subestructural (e irrestricto) -----------------------


ssu (str, Var x ,inf)         =  (str, Var x ,inf)
ssu (str, O (o,t) es ,inf)  =
  case and (map isCt es)  of
    (True)  -> if ctest str xs == [] then (str' , Var x , setMmax inf (tamb str')) 
                                     else (str, Var interrupcion,inf)
                where x   = newVar str -- if xs'==[] then newVar str else head xs'
                      xqs = map (\(Var x,q) -> (x,q)) (filter (\(e,q) ->isVar e) (zip es qs))
                      xs  = map fst xqs 
                      vs  = map ((value str).var) es
                      es' = map (\(Var x) -> x) es
                      v   = case o of 
                             ConOp  -> if length es < 2 then error "Small ssu : operador (:) con menos de dos argumentos"
                                                        else Vl (head es') (head (tail es'))
                             DConOp -> if length es < 3 then error "Small ssu : operador [:] con menos de tres argumentos"
                                                        else Vl (head (tail es')) (head (tail (tail es')))
                             HeadOp  -> if length es < 1 then error "Small ssu : operador head con menos de un argumentos"
                                                        else valueHead str (head vs)
                             TailOp  -> if length es < 1 then error "Small ssu : operador tail con menos de un argumentos"
                                                        else valueTail str (head vs)                                                        
                             _      -> appop o vs
                      xs' = case o of 
                             ConOp  -> [] -- constructor no desecha
                             DConOp -> map fst (filter (\(x,q) -> q==Su) (take 1 xqs))  
                                       -- constructor mixto, desecha sólo el primero
                             _      -> map fst (filter (\(x,q) -> q==Su) xqs)
                      str' = comaStr (filt xs' str) [(x,v)]
                      qs    = map qTau (dop t)
                      q     = qTau (iop t)  
    (False) -> (str' , O (o,t) (esct ++ (e0': tail esnct)) , inf') 
                where (str',e0',inf') = ssu (str, e0 ,inf)
                      esct  = takeWhile isCt es
                      esnct = dropWhile isCt es 
                      e0    = head esnct

ssu (str, Lam p e ,inf)  =  ssu (str', Var x ,setMmax inf (tamb str')) 
                where x = newVar str
                      v = Vf p e
                      str' = comaStr str [(x,v)]

ssu (str, App f e,inf) = case isCt e of
                                        (False) ->  (str1 , App f e1,inf1) --error (concat (map f ((\(Tup q es) -> es) e)))  
                                                     where (str1, e1 ,inf1) = ssu (str,e,inf)
                                                           --f (Var x) = x
                                                           --f(O (Q q s) o k ts es) = editQu q 
                                        (True)  ->  (str, sust mst e0 , setP inf (length mst))
                                                     where vf    = value str f
                                                           mst   = msust [] p0 e
                                                           p0    = (\(Vf p e) -> p) vf
                                                           e0    = (\(Vf p e) -> e) vf
                                                          
ssu (str,Tup es,inf) = case and (map isCt es) of
                                    (True)  ->  (str , Tup es , inf)
                                    (False) ->  (str' , Tup (esct ++ (e': tail esnct)) ,inf') 
                                  where (str',e',inf') = ssu (str, head esnct ,inf)
                                        esct  = takeWhile isCt es
                                        esnct = dropWhile isCt es 

ssu (str, If (Var b) e' e'' ,inf)  = if ctest str [b] == [] then case value str b  of (Vb True)  -> (str',e',inf') 
                                                                                      (Vb False) -> (str',e'',inf')
                                      else (str, Var ("ejecución interrumpida") ,inf)
    where str' = filt [b] str
          inf' = setMmax inf (tamb str')
                                   
                                                                               
ssu (str, If e0 e' e'' ,inf)  = (str', If e0' e' e'' ,inf')   where (str',e0',inf') = ssu (str,e0,inf)
ssu (str, Let p e e' ,inf)  = 
      case isCt e of
           (False) ->  (str1 , Let p e1 e' , inf1) where (str1,e1 ,inf1) = ssu (str,e,inf)
           (True)  ->  (str , sust mst e' , setP inf (length mst))  where mst = msust [] p e

ssu (str, Case q e e' p e'' ,inf)  = 
      case (e,q) of
           (Var x,Su)   ->  case value str x of  
                             VN      -> (str' , e' , setMmax inf (tamb str'))
                             Vl z zs -> (str' , sust mst e'' , setMmax (setP inf (length mst)) (tamb str') ) 
                                         where mst = msust [] p (Tup [Var z,Var zs])
                        where str' = filt [x] str
           (Var x,_)    ->  case value str x of  
                             VN      -> (str , e' , inf)
                             Vl z zs -> (str , sust mst e'' , setP inf (length mst) ) 
                                         where mst = msust [] p (Tup [Var z,Var zs])
           _       ->  (str1 , Case q e1 e' p e'' , inf1) where (str1,e1 ,inf1) = ssu (str,e,inf)


ssu (str, e , inf) = error ("Small ssu : no esta implementada la sem. small step para " ++ show e)

-------------------------------------------------------------------------------
-- Small Step Semantic: Global CP ---------------------------------------------


sgl xs (str, Var x ,inf)     =  (str, Var x ,inf)
sgl xs (str, O (o,t) es ,inf)  =
 case qTau (iop t) of
    Lo  -> case and (map isCt es) of
               (True)  -> (comaStr str [(x,v)] , Var x , setM inf (tamv (x,v)))
                          where x   = newVar str
                                vs  = map ((value str).var) es
                                es' = map (\(Var x) -> x) es
                                v   = case o of 
                                       ConOp  -> if length es < 2 then error "Small ssu : operador (:) con menos de dos argumentos"
                                                                   else Vl (head es') (head (tail es'))
                                       DConOp -> if length es < 3 then error "Small ssu : operador [:] con menos de tres argumentos"
                                                                   else Vl (head (tail es')) (head (tail (tail es')))
                                       HeadOp  -> if length es < 1 then error "Small ssu : operador head con menos de un argumentos"
                                                        else valueHead str (head vs)
                                       TailOp  -> if length es < 1 then error "Small ssu : operador head con menos de un argumentos"
                                                        else valueTail str (head vs)                                                        
                                       _      -> appop o vs
               (False) -> (str' , O (o,t) (esct ++ (e0': tail esnct)) ,inf') 
                          where (str',e0',inf') = sgl xs (str, e0 ,inf)
                                esct  = takeWhile isCt es
                                esnct = dropWhile isCt es 
                                e0    = head esnct
    (Gl (Var x)) ->  case and (map isCt es)  of
                           (True)  -> (comaStr str [(x,v)] , Var x , inf) 
                                        where vs  = map ((value str).var) es
                                              es' = map (\(Var x) -> x) es
                                              v   = case o of 
                                                      ConOp  -> if length es < 2 
                                                                then error "Small ssu : operador (:) con menos de dos argumentos"
                                                                else Vl (head es') (head (tail es'))
                                                      DConOp -> if length es < 3 
                                                                then error "Small ssu : operador [:] con menos de tres argumentos"
                                                                else Vl (head (tail es')) (head (tail (tail es')))
                                                      HeadOp  -> if length es < 1 
                                                                 then error "Small ssu : operador head con menos de un argumentos"
                                                                 else valueHead str (head vs)
                                                      TailOp  -> if length es < 1 
                                                                 then error "Small ssu : operador tail con menos de un argumentos"
                                                                 else valueTail str (head vs)                               
                                                      _      -> appop o vs
                           (False) -> (str' , O (o,t) (esct ++ (e0': tail esnct)) , inf') 
                                       where (str',e0',inf') = sgl xs (str, e0 ,inf)
                                             esct  = takeWhile isCt es
                                             esnct = dropWhile isCt es 
                                             e0    = head esnct
    (Gl e)  -> error ("Small sgl (caso O) : el tipo básico tiene calificador global  " ++ show e) 

--sgl xs (str, O (o,t) es ,inf)  = error ("sgl: operador de tipo compuesto: " ++ show (O (o,t) es) ++ " : " ++ show t)

sgl xs (str, Case q (Var l) e' p e'' ,inf)  = case value str l of 
                                                    (VN)      ->  (str,e',inf) 
                                                    (Vl x xs) ->  (str, sust mst e'',setP inf (length mst)) 
                                                                     where mst = msust [] p (Tup [Var x,Var xs])

sgl xs (str, App f e,inf) = case isCt e of
                                        (False) -> (str1 , App f e1,inf1) 
                                                     where (str1, e1 ,inf1) = sgl xs (str,e,inf)
                                                           g (O (SustrOp,t) es ) = True
                                                           g e = False
                                        (True)  -> (str, sust mst e0 , setP inf (length mst))
                                                     where vf    = value str f
                                                           mst   = msust xs p0 e
                                                           p0    = (\(Vf p e) -> p) vf
                                                           e0    = (\(Vf p e) -> e) vf
                                                           

sgl xs (str,Tup es,inf) = case and (map isCt es) of
                                    (True)  ->  (str , Tup es , inf)
                                    (False) ->  (str' , Tup (esct ++ (e': tail esnct)) ,inf') 
                                  where (str',e',inf') = sgl xs (str, head esnct ,inf)
                                        esct  = takeWhile isCt es
                                        esnct = dropWhile isCt es 

sgl xs (str, If (Var b) e' e'' ,inf)  = case value str b of 
                                                    (Vb True)  -> (str,e',inf) 
                                                    (Vb False) -> (str,e'',inf)

sgl xs (str, If e0 e' e'' ,inf)  = (str', If e0' e' e'' ,inf')  where (str',e0',inf') = sgl xs (str,e0,inf)
sgl xs (str, Let p e e' ,inf)  = 
      case isCt e of
           (False) ->  (str1 , Let p e1 e' , inf1 )  where (str1,e1 ,inf1) = sgl xs (str,e,inf)
           (True)  ->  (str , sust mst e' , setP inf (length mst)) where mst = msust  xs p e

sgl xs (str, e ,inf) = error ("sgl:  sin ecuaciones para " ++ show e)





-----------------------------------------------------------------------
-- Funciones de tamaño de memoria

-- tam, tamb : Refleja sólo la cantidad de "unidades" de tipos básicos
tamv (x,Vb b)      = 0
tamv (x,Vi i)      = 1 
tamv (x,Vf p e)    = 0
tamv (x,Va a)      = length a    
tamv (x,VN)        = 1
tamv (x,Vl z zs)   = 1

tamb [] = 0
tamb ((x,Vb b): str)      = tamb  str
tamb ((x,Vi i): str)      = 1 + tamb  str
tamb ((x,Vl a b): str)    = 1 + tamb  str
tamb ((x,VN): str)        = 1 + tamb  str
tamb ((x,Vf p e): str)    = tamb  str               
tamb ((x,Va a): str)      = length a  + tamb  str  

--maxStr cs = maxL 0 cs
-- where maxL k [] = k
--       maxL k (c:cs) = maxL (max k (length (c str c))) cs 
--       max i j = if i < j then j else i 
                        
-------------------------------------------------------------------------------
-- Aplicar operadores usuales vistos como operadores estandard

appop :: Sig -> [Value] -> Value
appop (VbOp b) vs = Vb b
appop (ViOp i) vs = Vi i
appop IdOp (v:vs) = v
appop AddOp ((Vi n) : ((Vi m) : vs)) = Vi (n+m)
appop IncOp ((Vi n) : vs) = Vi (n+1)
appop AddInvOp ((Vi n) : vs) = Vi (-n)
appop MeOp ((Vi i) : ((Vi i') : vs)) = Vb (i<i')
appop MiOp ((Vi i) : ((Vi i') : vs)) = Vb (i<=i')
appop EqualOp ((Vi i) : ((Vi i') : vs)) = Vb (i==i')
appop MultOp ((Vi n) : ((Vi m) : vs)) = Vi (n*m)
appop SustrOp ((Vi n) : ((Vi m) : vs)) = Vi (n-m)
appop DivOp ((Vi n) : ((Vi m) : vs)) = Vi (div n m)
appop ModOp ((Vi n) : (( Vi m) : vs)) = Vi (mod n m)
appop OrOp ((Vb b) : ((Vb b') : vs)) = Vb (b||b')
appop AndOp ((Vb b) : ((Vb b') : vs)) = Vb (b&&b')
appop P1Op (v1 : (v2 : vs)) = v1
appop P2Op (v1 : (v2 : vs)) = v2
appop NewOp ((Vi n) : vs) = Va (new n)
appop EntryOp ((Va a) : ((Vi i) : vs)) = Vi (entry a i)
appop DEntryOp ((Va a) : ((Vi i) : ((Vi n) : vs))) = Vi (entry a i)
appop UpdOp ((Va a) : ((Vi i) : ((Vi k) : vs))) = Va (upd a i k)
appop (EqOp k) ((Vi n) : vs) = Vb (k==n)
appop (AdOp k) ((Vi n) : vs) = Vi (k+n)
appop (MuOp k) ((Vi n) : vs) = Vi (k*n)
appop (DiOp k) ((Vi n) : vs) = Vi (div n k)
appop (SuOp k) ((Vi n) : vs) = Vi (n-k)
appop NullOp vs = VN
appop IsNullOp ((Vl x xs):vs) = Vb False
appop IsNullOp (VN:vs) = Vb True
appop ConOp vs = error "Small appop: ConOp"
appop HeadOp vs = error "Small appop: HeadOp"
appop TailOp vs = error "Small appop: TailOp"

appop o vs = error ("appop: no esta definida o faltan argumentos para la operación: " ++ (codop o)) 

valueHead str (Vl x xs) = value str x
valueHead str v = error ("Small/valueHead: " ++ show v)
valueTail str (Vl x xs) = value str xs
valueTail str v = error ("Small/valueTail: " ++ show v)

-------------------------------------------------------------------------------
-- funciones para proveer nuevas variables en la ejecución --------------------

-- maxima variable que empieza con 'c'

maxVar c  str =  maximo (map num (map tail (filter (empieza c) (map fst  str))))
 where empieza c [] = error "newVar : string vacía"
       empieza c (c':cs) = if c==c' then True else False
       maximo [] = 0
       maximo (n:ns) = max n (maximo ns)

num :: String -> Int
num ('0':[]) = 0
num ('1':[]) = 1
num ('2':[]) = 2
num ('3':[]) = 3
num ('4':[]) = 4
num ('5':[]) = 5
num ('6':[]) = 6
num ('7':[]) = 7
num ('8':[]) = 8
num ('9':[]) = 9
num (d:cs)   = num (d:[]) * pot (length cs) + num cs
 where pot 0 = 1
       pot k = 10 * pot (k-1)

-- número de variables utilizadas que empiezan con c
-- minVar c [] = 0
-- minVar c ((c':vs,v): str) = (if c == c' then 1 else 0) + minVar c  str 

-- función proveedora de nuevas variables

newVar  str = "v" ++ show (k+1) where k = maxVar 'v'  str


---------------------------------------------------------------------------------
-- NO EXPORTABLES ---------------------------------------------------------------
---------------------------------------------------------------------------------
-- Funciones auxiliares----------------------------------------------------------

---------------------------------------------------------------------
-- Operaciones sobre valores de los tipos primitivos ----------------

fs []      =   error "fs: tupla o array vacio"
fs (x:xs)  = x
sn []      =   error "sn: tupla o array vacio"
sn (x:[])  =   error "sn: tupla o array con sólo un elemento"
sn (x:xs)  = fs xs
th []      =   error "th: tupla o array vacio"
th (x:[])  =   error "th: tupla o array con sólo un elemento"
th (x:(y:[])) =   error "th: tupla o array con sólo dos elemento"
th (x:xs)  = sn xs

--  elimina variables de un store


filt :: [Var] -> Str ->  Str
filt []  str        =  str
filt (x:xs)  str    = filt xs (f x  str)
  where f x [] = []
        f x (p:ps)  = if x == fst p  then f x ps else p : f x ps

