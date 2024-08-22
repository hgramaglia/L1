# L1
Make clear what linear type systems bring to the process of incorporating update in-place. Implementation of the languages, weak-lineal and global type checking, and linearization and globalization algorithms, all of them  described Gramaglia (2024).  

## Installation

Load module Main into a Haskell interpreter. Call function 'main' to see the main functions of the proptotype.

MAIN FUNCTIONS:
sh "pro.m"           show pro.m (m=un,su,lo,gl)
tc "pro.m"           type checking of pro.m (m=un,su,lo,gl)
ev "pro.m"           evaluate pro.m (m=un,su,lo,gl)
unsig "pro"          generate from (str,e) the (unrestricted) signature 
dosub "pro"          generates linearizations from pro.un (does not read type)
doglo "pro"          generates globalizations from pro.lo (read the type)
ispro "pro"          linear and global type checking, protection checking (from pro.su and pro.gl) 

1) In folder "Programs" there are many developed examples (all those reported in [1]). Each file shows the text of a program, with the format shown below. In the '.un' and '.su' files, the last field corresponding to the type of the program may be missing.

x=4,
y=1                              Store
-----
2*x + y                          Expression
-----
2 : su int,
* : (su int,un int) -> un int
+ : (un int,su int) -> su int    Signature
-----
x:un int,
y:su int                         Type Context
-----                            
su int                           Expression Type (may be missing)
----- 
 
2) The files '.lo' and '.un' are displayed by the 'sh' function in their correct form (all 'un' or 'lo'). In the file, the contexts (and in some cases the signature) may contain other qualifiers, because they are input to the
linearization and globalization algorithms. The file '.un' usually contains the qualifiers 'su' or 'un!'. This also reduces the complexity of the algorithm. That is why when unrestricted execution is desired, the signature of the file 'un' is not read, but is calculated from the store and the expression.

3) When designing a new program "pro.un", it is not necessary to complete the signature, you can write an incomplete file:

w = 2,
x = 10
------------------------------------
-x * (w+x) 
------------------------------------

Use 'unsig "pro.un"' to display the unrestricted signature. Copy and paste into pro.un.

4) When reading the '.su' and '.gl' files, the first program text that appears is taken. The linearization algorithm (or the globalization algorithm) can generate several program texts that are presented in the same file.

5) 'un!' means that the linearization algorithm does not touch them (it decreases the complexity). The file '.un' usually contains the qualifier 'su' in the signature, thus also decreasing the complexity of the algorithm. That is why when unrestricted execution is desired, the signature is calculated from the store and the expression (it is not read from the file).

6) The parser was built with Happy (Version 1.19.12).

Gramaglia, H. (2024) Weak-linearity, globality and in-place update
