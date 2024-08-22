
module Main

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
import Control.Monad
import Edit


pupath  = "Programas/" 
capath  = "Programas/"
 
main = putStr menustr

{-
Definiciones básicas:

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

PP (Programa plus tipo):    (pi,str,e,t)   (no se muestran, siempre se muestra TEP o TEPT)
-}

menustr =
  "\n" ++
  "\n" ++
  "sh \"pro.m\"           show pro.m (m=un,su,lo,gl)\n"++
  "tc \"pro.m\"           type checking of pro.m (m=un,su,lo,gl)\n"++
  "ev \"pro.m\"           evaluate pro.m (m=un,su,lo,gl)\n"++
  "us \"pro\"             generate from store and expression the (unrestricted) signature\n"++
  "dosub \"pro\"          generates linearizations from pro.un (does not read type)\n"++
  "doglo \"pro\"          generates globalizations from pro.lo (read the type)\n"++
  "ispro \"pro\"          linear and global type checking, protection checking (from pro.su and pro.gl)\n"++
  "\n\n"


-------------------------------------------------------------------
-- Auxiliares -----------------------------------------------------

modo s = mode (ter s)  
 where
      mode "un" = Irrestricto
      mode "su" = Subestructural
      mode "lo" = Local
      mode "gl" = Global []  

ter s = if m==[] then error "Debe ingresar el nombre del archivo con su extensión .m (m=un,su,lo,gl)"
                 else tail m
 where m = dropWhile ((/=) '.') s       

-- Lectura sin tipo
readTEP s      = do  tep       <- readFile (capath ++ s) 
                     sp        <- return (separar tep) 
                     putStr ("Leyendo modalidad " ++ ter s ++ "\n")
                     str       <- ((pstr . etalexer) (part 0 sp))
                     putStr "Store ok, "
                     e         <- ((pexc . lexer) (part 1 sp))
                     putStr "Expression ok, "
                     sig0      <- ((psigma . lexer) (part 2 sp))   
                     sig       <- return (setminus sig0)
                     putStr "Signature ok, "
                     pi        <- ((ppi . taulexer) (part 3 sp))
                     putStr "Type Context ok.\n"
                     return (pi,str,e,[],sig) 

-- Lectura con tipo (en la parte 4)
readTEPT s     = do  tep       <- readFile (capath ++ s) 
                     sp        <- return (separar tep) 
                     putStr ("Leyendo modalidad " ++ ter s ++ "\n")
                     str       <- ((pstr . etalexer) (part 0 sp))
                     putStr "Store ok, "
                     e         <- ((pexc . lexer) (part 1 sp))
                     putStr "Expression ok, "
                     sig0      <- ((psigma . lexer) (part 2 sp))   -- signatura significativa
                     sig       <- return (setminus sig0)
                     putStr "Signature ok, "
                     pi        <- ((ppi . taulexer) (part 3 sp))
                     putStr "Type context ok."
                     t         <-  ((ptau . lexer) (part 4 sp))
                     putStr "Expression type ok.\n"
                     return (pi,str,e,[],sig,t) 

-- Lectura str y e solamente, de archivo .un y .lo: es para generar la signatura de base
readP    s     = do  tep    <- readFile (capath ++ s) 
                     sp        <- return (separar tep) 
                     str       <- ((pstr . etalexer) (part 0 sp))
                     e         <- ((pexc . lexer) (part 1 sp))
                     return (str,e) 


-- Obtine PP infiriendo el tipo
califTEP m (pi,str0,e0,ts,sig) = 
 case m of
  "un"  -> (pi',str,e,tkTau pi' e)     
                        where (str,e)   = putC (str0,e0) (putSigma Un sig)
                              -- puede haber algún su en la signatura irrestricta
                              -- por optimización del algoritmo de linealización
                              pi'       = putPi Un pi
                              -- los tipos están subestructuralizados para el algoritmo
  "lo"  -> (pi',str,e,tkTau pi' e)     
                        where (str,e)   = putC (str0,e0) sig
                              pi'       = putPi Lo pi
                              -- los tipos están globalizados para el algoritmo
  _     -> (pi,str,e,tkTau pi e)  
                       where (str,e)   = putC (str0,e0) sig


-- Obtiene PP de la lectura -- sólo para archivos lo y gl
califTEPT m (pi,str0,e0,ts,sig,t) = 
 case m of
    "lo"  -> (putPi Lo pi,str,e,putTau Lo t)   -- los tipos están globalizados para el algoritmo
    _     -> (pi,str,e,t)   
  where (str,e)  = putC (str0,e0) sig
  
  
-- f_ = función f aplicada a un PP
sigma_ (pi,str,e,t) = sigma (str,e)
red_ m xs (pi,str,e,t) = case m of
                         "un" -> last (red Subestructural (str,e,(tamb str,tamb str,0)))
                         "su" -> last (red Subestructural (str,e,(tamb str,tamb str,0)))
                         "lo" -> last (red (Global []) (str,e,(tamb str,tamb str,0)))
                         "gl" -> last (red (Global xs) (str,e,(tamb str,tamb str,0)))
test_ m (pi,str,e,t) = ((pi,str,e,t),test pi (str,e) t)
mtest_ m eps = map (test_ m) eps 
editTest_ m ((pi,str,e,t),txs) = editPPTest ((pi,str,e,t),txs)
glo_ (pi,str,e,t) = map (\(str',e') -> (pi,str',e',t)) (glo pi (str,e) t)
sub_ (pi,str,e,t) = map (\(str',e',t') -> (pi,str',e',t')) (sub pi (str,e))

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Funciones principales
--------------------------------------------------------------------------------------

-- Solo lee str y e para generar la signatura un
unsig s = 
          if null s then return()
          else do (str,e)         <- readP s
                  sig             <- return (sigma (str,e))
                  str1            <- return ("\n\n" ++ editSigma sig ++ 
                                             "\nRevisar los tipos de los elementos de las listas que pueden no ser correctos\n"  )
                  putStr (str1)

-- Muestra el primer TEPT del archivo s.m, si es gl muestra su forma de comando
sh s =  
         if null s then return()
         else do tup            <- readTEP s
                 m              <- return (ter s)
                 (pi,str,e,t)   <- return (califTEP m tup) 
                 putStr ("\n" ++  editPP (pi,str,e,t)  ++ (if m == "gl" then editCom (pi,str,e,t) else [] ) ++ "\n\n" )
       
-- Evalúa el primer TEPT del archivo s.m
ev s = 
          if null s then return()
          else do tup            <- readTEP s
                  m              <- return (ter s)
                  (pi,str,e,t)   <- return (califTEP m tup) 
                  c              <- return (red_ m (glPi pi) (pi,str,e,t))
                  string0        <- return ("\n" ++  editPP (pi,str,e,t) ++ "\n" ++ editConfig (modo m) c ++ "\n\n" ) 
                  putStr (string0 ++ "\n" ) 


                  
-- Test subestructural de TEPT su
tc s = 
          if null s then return()
          else do tup            <- readTEP s
                  m              <- return (ter s)
                  (pi,str,e,t)   <- return (califTEP m tup)
                  string0        <- return (editTest_ m (test_ m (pi,str,e,t)))
                  putStr (string0) 

ispro s = 
          if null s then return()
          else 
               do qtup                  <- readTEP (s++".su")
                  (qpi,qstr,qe,qt)      <- return (califTEP "su" qtup)
                  gtup                  <- readTEP (s++".gl")
                  (gpi,gstr,ge,gt)      <- return (califTEP "gl" gtup)
--                Test Subestructural
                  qtx                   <- return (snd (test_ "su" (qpi,qstr,qe,qt))) 
--                Test Global
                  gtx                   <- return (snd (test_ "gl" (gpi,gstr,ge,gt))) 
--                Edición
--                Protección
                  txpr                  <- return (editProt (sigma_ (qpi,qstr,qe,qt)) (sigma_ (gpi,gstr,ge,gt)))
                  putStr ("\n\n" ++ txpr ++ editTypeTest "su" qtx ++  editTypeTest "gl" gtx )  
                  
-- Aplica algo de subestructuralización a TEPT un, escribe en archivo los TEPT resultantes y los resultados de la ejecución,
-- muestra en pantalla un resumen
dosub s = 
          if null s then return()
          else do tup               <- readTEP (s ++ ".un")
                  (pi,str,e,t)      <- return (califTEP "su" tup)
                  pps               <- return (sub_ (pi,str,e,t)) 
                  strs              <- return (meditPP pps)
                  writeFile (capath ++  s ++ ".su") strs
                  putStr ("\n El algoritmo de linealización produjo " ++ show (length pps) ++ " linealizaciones\n\n")

doglo s = 
          if null s then return()
          else do tup               <- readTEPT (s ++ ".lo")
                  (pi,str,e,t)      <- return (califTEPT "gl" tup)
                  pps               <- return (glo_ (pi,str,e,t)) 
                  strs              <- return (meditPP pps)
                  writeFile (capath ++  s ++ ".gl") strs
                  putStr ("\n El algoritmo de globalización produjo " ++ show (length pps) ++ " globalizaciones\n\n")



-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- auxiliares

tkpi (pi,str,e,t,ts)  = pi
tktau (pi,str,e,t,ts) = t
tkstr (pi,str,e,t,ts) = str
tkexc (pi,str,e,t,ts) = e
tktaus (pi,str,e,t,ts) = ts

------------------------------------------------------------------------------------
--Otras funciones

----------------------------------------------------------------------------------------
-- Procesamiento de archivos .su y .gl -------------------------------------------------
-- TEXTO ESTANDARD DE PROGRAMA (TEP)
-- En el se encuentra, en este orden:
-- part 0: store
-- part 1: expresión
-- part 2: signautra
-- part 3: entorno de tipos
-- part 4: tipo (se parsea sólo en archivos .gl, o para test en .su)
-- SEPARADOR: 
-- __________________________________
--
-- PRODUCCIÓN DE ALGORITMOS DE SUBESTRUCTURALIZACIÓN O GLOBALIZACIÓN:
-- Secuencia donde cada uno responde a la estructura TEP, de manera
-- que se puede leer con sho, sho, dotc, etc.
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- Auxiliar para procesar archivos 

-- separar el archivo que contiene toda la información. Separador: "\n"++"--"
separar s = secP (secR s)

part k [] = []
part 0 (p:ps) = concatren p
                where concatren [] = []
                      concatren (r:rs) = r ++ "\n" ++ concatren rs
part k (p:ps) = part (k-1) ps  
-- tomar parte, quitar parte
takeP sr = takeWhile norsep sr
dropP sr = dropWhile norsep sr
secP_ sp []  = sp
secP_ sp sr   = if sr' == [] then sp ++ [p] else secP_ (sp ++ [p]) (tail sr')
                where p = takeP sr
                      sr' = dropP sr 
secP s = secP_ [] s
-- tomar y quitar renglón, secuencia de renglones
takeR s = takeWhile nofsep s
dropR s = dropWhile nofsep s
secR_ sr []  = sr
secR_ sr s   = if s == r then sr ++ [r] else secR_ (sr ++ [r]) (tail (dropR s))
               where r = takeR s 
secR s = secR_ [] s
-- separador de renglón
fsep c = (c == '\n') 
nofsep c = not (fsep c)
-- separador de parte
rsep ren =  if length ren' >= 2 then  (head ren' == '-') && (head (tail ren') == '-') else False
            where ren' = dropWhile (\c->(c==' ')) ren
norsep ren = not (rsep ren)

-- mini-parser de secuencias de variables

parsevar s = (if s'==[] then [] else [s']) ++ (if s''==[] then [] else parsevar (tail s'')) 
               where s'' = dropWhile (\a -> a/=' ' && a/=',') s 
                     s'  = takeWhile (\a -> a/=' ' && a/=',') s


