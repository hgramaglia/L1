


module Alg  -- Algebra
 (
  Sort,
  Sig(VbOp,ViOp,IdOp,PopOp,P1Op,P2Op,IncOp,AddOp,AddInvOp,MultOp,SustrOp,ModOp,DivOp,EqualOp,
      MeOp,MiOp,AndOp,OrOp,NotOp,NewOp,UpdOp,EntryOp,DEntryOp,
      MuOp,DiOp,EqOp,SuOp,AdOp,NullOp,ConOp,DConOp,IsNullOp,HeadOp,TailOp),
  codop,stOp,editOp,editOpc,
  Array,new,upd,entry,showArray
 )

where

import Aux

type Sort  = String     

-- SIGNATURA

data Sig = VbOp Bool  | ViOp Int |                                         
           IdOp    |  PopOp  Int |  AddInvOp | NotOp | IncOp |                
           EqOp Int |  AdOp Int | DiOp Int | SuOp Int |  MuOp Int |        
           P1Op    | P2Op | AddOp | MultOp | SustrOp | ModOp | DivOp |     
           EqualOp | MeOp | MiOp | AndOp | OrOp  | NewOp |  UpdOp | EntryOp | DEntryOp | 
           NullOp  | ConOp | DConOp | IsNullOp | HeadOp | TailOp
 deriving (Eq)


codop AddOp = "+"
codop MultOp = "*"
codop SustrOp = "-"
codop AddInvOp = "-"
codop IncOp = "inc"
codop (PopOp k) = "pop" ++ show k
codop ModOp = "mod"
codop DivOp = "%"
codop EqualOp = "=="
codop MeOp = "<"
codop MiOp = "<="
codop AndOp = "&&"
codop OrOp = "||"
codop NotOp = "not"
codop (ViOp v) = show v
codop (VbOp True) = "true"
codop (VbOp False) = "false"
codop IdOp = "id"
codop P1Op = "p1"
codop P2Op = "p2"
codop NewOp = "new"
codop UpdOp = "upd"
codop (AdOp k) = "+" ++ show k
codop (DiOp k) = "%" ++ show k
codop (EqOp k) = "==" ++ show k
codop (SuOp k) = "-" ++ show k
codop (MuOp k) = "*" ++ show k
codop EntryOp = "ent"
codop DEntryOp = "den"
codop NullOp = "[]"
codop ConOp = ":"
codop DConOp = "[:]"
codop IsNullOp = "isNull"
codop TailOp = "tail"
codop HeadOp = "head"



editOp x IdOp  ss = (if x==[] then [] else x ++ ":=") ++ "id(" ++ head ss ++ ")" 
editOp x (SuOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(-" ++ show k ++ ") " ++ head  ss 
editOp x (AdOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(+" ++ show k ++ ") " ++ head  ss 
editOp x (MuOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(*" ++ show k ++ ") " ++ head  ss 
editOp x (DiOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(%" ++ show k ++ ") " ++ head  ss
editOp x (EqOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(==" ++ show k ++ ") " ++ head  ss  
editOp x NewOp  ss = (if x==[] then [] else x ++ ":=") ++ "new(" ++ (head  ss) ++ ")"
editOp x IncOp  ss = (if x==[] then [] else x ++ ":=") ++ "inc(" ++ (head  ss) ++ ")"
editOp x IsNullOp  ss = (if x==[] then [] else x ++ ":=") ++ "isNull(" ++ (head  ss) ++ ")"
editOp x HeadOp  ss = (if x==[] then [] else x ++ ":=") ++ "head(" ++ (head  ss) ++ ")"
editOp x TailOp  ss = (if x==[] then [] else x ++ ":=") ++ "tail(" ++ (head  ss) ++ ")"
editOp x P1Op  ss = (if x==[] then [] else x ++ ":=") ++ "p1(" ++ (head  ss) ++ "," ++ (head (tail  ss)) ++ ")"
editOp x P2Op  ss = (if x==[] then [] else x ++ ":=") ++ "p2(" ++ (head  ss) ++ "," ++ (head (tail  ss)) ++ ")"
editOp x EntryOp  ss = (if x==[] then [] else x ++ ":=") ++ (head  ss) ++ "[" ++ (head (tail  ss)) ++ "]"
editOp x DEntryOp  ss = (if x==[] then [] else x ++ ":=" ) ++ (head  ss) ++ "[" ++ (head (tail  ss)) ++ "," ++ s3 ++ "]" 
 where s3 = if length ss < 3 then error ("Alg/editOp: no hay tres argumentos para .[.,.]") else head ((tail.tail) ss)                        
editOp [] o  ss =  case length  ss of 
                            0 ->  codop o
                            1 -> "(" ++ codop o ++ (if o==NotOp then " " else []) ++ (head  ss) ++ ")" 
                            2 -> "(" ++ (head  ss) ++ codop o ++ (head (tail  ss)) ++ ")"
                            3 -> case o of
                                  UpdOp  -> (head  ss) ++ "[" ++ (head (tail  ss)) ++ "<-" 
                                                              ++ (head ((tail.tail)  ss)) ++ "]"
                                  DConOp -> (head  ss) ++ "[" ++ (head (tail  ss)) ++ ":" 
                                                              ++ (head ((tail.tail)  ss)) ++ "]"
editOp x o  ss =  case length  ss of 
                            0 -> x ++ ":=" ++ codop o
                            1 -> x ++ ":=" ++ "(" ++ codop o ++ (if o==NotOp then " " else []) ++ (head  ss) ++ ")" 
                            2 -> x ++ ":=" ++ "(" ++ (head  ss) ++ codop o ++ (head (tail  ss)) ++ ")"
                            3 -> case o of
                                  UpdOp  -> if x == head  ss then (head  ss) ++ "[" ++ (head (tail  ss)) ++ "]:=" 
                                                                   ++ (head ((tail.tail)  ss))
                                                             else x ++ ":=" ++ (head  ss) ++ "[" ++ (head (tail  ss)) 
                                                                   ++ "<-" ++ (head ((tail.tail)  ss)) ++ "]"  
                                  DConOp -> if x == head  ss then (head  ss) ++ ":=(" ++ (head (tail  ss)) ++ ":" 

                                                                   ++ (head ((tail.tail)  ss)) ++ ")"
                                                             else x ++ ":=" ++ (head  ss) ++ "[" ++ (head (tail  ss)) 
                                                                    ++ ":" ++ (head ((tail.tail)  ss)) ++ "]"

-- edit operador para comandos (id,p1,p2 no se escriben)
editOpc x IdOp  ss = if x==[] || x==head ss then head  ss else x ++ ":=" ++ head ss 
editOpc x (SuOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(-" ++ show k ++ ") " ++ head  ss 
editOpc x (AdOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(+" ++ show k ++ ") " ++ head  ss 
editOpc x (MuOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(*" ++ show k ++ ") " ++ head  ss 
editOpc x (DiOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(%" ++ show k ++ ") " ++ head  ss
editOpc x (EqOp k)  ss = (if x==[] then [] else x ++ ":=") ++ "(==" ++ show k ++ ") " ++ head  ss  
editOpc x NewOp  ss = (if x==[] then [] else x ++ ":=") ++ "new(" ++ (head  ss) ++ ")"
editOpc x IncOp  ss = (if x==[] then [] else x ++ ":=") ++ "inc(" ++ (head  ss) ++ ")"
editOpc x IsNullOp  ss = (if x==[] then [] else x ++ ":=") ++ "isNull(" ++ (head  ss) ++ ")"
editOpc x HeadOp  ss = (if x==[] then [] else x ++ ":=") ++ "head(" ++ (head  ss) ++ ")"
editOpc x TailOp  ss = (if x==[] then [] else x ++ ":=") ++ "tail(" ++ (head  ss) ++ ")"
editOpc x P1Op  ss = if x==[] then  (head  ss) else x ++ ":=" ++ head  ss 
editOpc x P2Op  ss = if x==[] then  head  (tail ss) else x ++ ":=" ++ head (tail  ss) 
editOpc x EntryOp  ss = (if x==[] then [] else x ++ ":=") ++ (head  ss) ++ "[" ++ (head (tail  ss)) ++ "]"
editOpc x DEntryOp  ss = if x==[] then (head  ss) ++ "[" ++ (head (tail  ss)) ++ "," ++ s3 ++ "]" 
                                 else x ++ ":=" ++ (if x==s3 then (head  ss) ++ "[" ++ (head (tail  ss)) ++ "]"
                                                    else (head  ss) ++ "[" ++ (head (tail  ss)) ++ "," ++ s3 ++ "]")
 where s3 = if length ss < 3 then error ("Alg/editOpc: no hay tres argumentos para .[.,.]") else head ((tail.tail) ss)                        
editOpc [] o  ss =  case length  ss of 
                            0 ->  codop o
                            1 -> "(" ++ codop o ++ (if o==NotOp then " " else []) ++ (head  ss) ++ ")" 
                            2 -> "(" ++ (head  ss) ++ codop o ++ (head (tail  ss)) ++ ")"
                            3 -> case o of
                                  UpdOp  -> (head  ss) ++ "[" ++ (head (tail  ss)) ++ "<-" 
                                                              ++ (head ((tail.tail)  ss)) ++ "]"
                                  DConOp -> (head  ss) ++ "[" ++ (head (tail  ss)) ++ ":" 
                                                              ++ (head ((tail.tail)  ss)) ++ "]"
editOpc x o  ss =  case length  ss of 
                            0 -> x ++ ":=" ++ codop o
                            1 -> x ++ ":=" ++ "(" ++ codop o ++ (if o==NotOp then " " else []) ++ (head  ss) ++ ")" 
                            2 -> x ++ ":=" ++ "(" ++ (head  ss) ++ codop o ++ (head (tail  ss)) ++ ")"
                            3 -> case o of
                                  UpdOp  -> if x == head  ss then (head  ss) ++ "[" ++ (head (tail  ss)) ++ "]:=" 
                                                                   ++ (head ((tail.tail)  ss))
                                                             else x ++ ":=" ++ (head  ss) ++ "[" ++ (head (tail  ss)) 
                                                                   ++ "<-" ++ (head ((tail.tail)  ss)) ++ "]"  
                                  DConOp -> if x == head  ss then (head  ss) ++ ":=(" ++ (head (tail  ss)) ++ ":" 
                                                                   ++ (head ((tail.tail)  ss)) ++ ")"
                                                             else x ++ ":=" ++ (head  ss) ++ "[" ++ (head (tail  ss)) 
                                                                    ++ ":" ++ (head ((tail.tail)  ss)) ++ "]"


-- Signature-Type de un operador (importa si es infijo, prefijo, etc.)
-- tipo 0: se escribe el código del operador antes que los argumentos
-- tipo k: se escribe el código del operador después de k argumentos

stOp AddOp = 1
stOp MultOp = 1
stOp SustrOp = 1
stOp AddInvOp = 0
stOp (SuOp k) = 0
stOp (AdOp k) = 0
stOp (DiOp k) = 0
stOp (EqOp k) = 0
stOp (MuOp k) = 0
stOp ModOp = 1
stOp DivOp = 1
stOp EqualOp = 1
stOp MeOp = 1
stOp MiOp = 1
stOp AndOp = 1
stOp OrOp = 1
stOp NotOp = 0
stOp (ViOp v) = 0
stOp (VbOp True) = 0
stOp (VbOp False) = 0
stOp IdOp = 0
stOp P1Op = 0
stOp P2Op = 0
stOp NewOp = 0
stOp UpdOp = 1    -- se toma [ como representante del código, que es upd
stOp EntryOp = 1  -- se toma [ como representante del código, que es ent
stOp DEntryOp = 1 -- se toma [ como representante del código, que es den
stOp NullOp = 0
stOp ConOp = 1 
stOp DConOp = 2  -- se toma :  
stOp IsNullOp = 0
stOp HeadOp = 0
stOp TailOp = 0


-- Tipo array

type Array = [Int]

showArray a = "{" ++ listAr a ++ "}"
 where listAr [] = []
       listAr (n:[]) = show n 
       listAr (n:ns) = show n ++ "," ++ listAr ns

new n = [0 | i <- [1..n]]  
entry a i = if tl==[] then error ("entry: no existe la entrada " ++ show i ++ " de " ++ showArray a) 
            else head tl
 where  tl = drop i a
upd a i k = if tl==[] then error ("upd: no existe el lugAr " ++ show i ++ " de " ++ showArray a) 
            else ini ++ [k] ++ tail tl
 where  tl = drop i a
        ini = take i a

