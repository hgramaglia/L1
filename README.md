# L1
Make clear what linear type systems bring to the process of incorporating update in-place. Implementation of the languages, weak-lineal and global type checking, and linearization and globalization algorithms, all of them  described Gramaglia (2024).  

## Installation

Load module Main into a Haskell interpreter. Call function 'main' to see the main functions of the proptotype.

1) In folder "Programs" there are many developed examples, all those reported in Gramaglia (2024). Each file shows the text of a program, listing consecutively store, expression, signature, type context, and type of the expression, separated by "--". In the '.un' and '.su' files, the last field corresponding to the type of the expression may be missing.
 
2) The files '.lo' and '.un' are displayed by the 'sh' function in their correct form (all 'un' or 'lo'). In the file, the contexts (and in some cases the signature) may contain other qualifiers, because they are input to the
linearization and globalization algorithms. The file '.un' usually contains the qualifiers 'su' or 'un!'. This also reduces the complexity of the algorithm. That is why when unrestricted execution is desired, the signature of the file 'un' is not read, but is calculated from the store and the expression.

3) When designing a new program "pro.un", it is not necessary to complete the signature, you can write an incomplete file (write only store and expression, ending with "--"). Use 'unsig "pro.un"' to display the unrestricted signature. Copy and paste into pro.un.

4) When reading the '.su' and '.gl' files, the first program text that appears is taken. The linearization algorithm (or the globalization algorithm) can generate several program texts that are presented in the same file.

5) 'un!' means that the linearization algorithm does not touch them (it decreases the complexity). The file '.un' usually contains the qualifier 'su' in the signature, thus also decreasing the complexity of the algorithm. That is why when unrestricted execution is desired, the signature is calculated from the store and the expression (it is not read from the file).

6) The parser was built with Happy (Version 1.19.12).

Gramaglia, H. (2024) Weak-linearity, globality and in-place update
