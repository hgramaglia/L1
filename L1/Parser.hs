{-# OPTIONS_GHC -w #-}
module Parser where
import Data.Char
import Aux
import Alg
import Exc
import Sig
import Small
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.12

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn11 (Sig)
	| HappyAbsSyn12 (Sigma)
	| HappyAbsSyn14 ([Pat])
	| HappyAbsSyn16 (Pat)
	| HappyAbsSyn17 (Qu)
	| HappyAbsSyn18 (Array)
	| HappyAbsSyn20 (Value)
	| HappyAbsSyn21 (Str)
	| HappyAbsSyn23 (Tau)
	| HappyAbsSyn24 ([Tau])
	| HappyAbsSyn26 (Pi)
	| HappyAbsSyn28 ([Exc])
	| HappyAbsSyn30 (Exc)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152,
 action_153,
 action_154,
 action_155,
 action_156,
 action_157,
 action_158,
 action_159,
 action_160,
 action_161,
 action_162,
 action_163,
 action_164,
 action_165,
 action_166,
 action_167,
 action_168,
 action_169,
 action_170,
 action_171,
 action_172,
 action_173,
 action_174,
 action_175,
 action_176,
 action_177,
 action_178,
 action_179,
 action_180,
 action_181,
 action_182,
 action_183,
 action_184,
 action_185,
 action_186,
 action_187,
 action_188,
 action_189,
 action_190,
 action_191,
 action_192,
 action_193,
 action_194,
 action_195,
 action_196,
 action_197,
 action_198,
 action_199,
 action_200,
 action_201,
 action_202,
 action_203,
 action_204,
 action_205,
 action_206,
 action_207,
 action_208,
 action_209,
 action_210,
 action_211,
 action_212,
 action_213,
 action_214,
 action_215,
 action_216,
 action_217,
 action_218,
 action_219,
 action_220,
 action_221,
 action_222,
 action_223,
 action_224,
 action_225,
 action_226,
 action_227,
 action_228,
 action_229,
 action_230,
 action_231,
 action_232,
 action_233,
 action_234,
 action_235,
 action_236,
 action_237,
 action_238,
 action_239,
 action_240,
 action_241,
 action_242,
 action_243,
 action_244,
 action_245,
 action_246,
 action_247,
 action_248,
 action_249,
 action_250,
 action_251,
 action_252,
 action_253,
 action_254,
 action_255,
 action_256,
 action_257,
 action_258,
 action_259,
 action_260,
 action_261,
 action_262,
 action_263,
 action_264,
 action_265,
 action_266,
 action_267,
 action_268,
 action_269,
 action_270,
 action_271,
 action_272,
 action_273,
 action_274,
 action_275,
 action_276,
 action_277,
 action_278 :: () => Int -> ({-HappyReduction (IO) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (IO) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (IO) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (IO) HappyAbsSyn)

happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83,
 happyReduce_84,
 happyReduce_85,
 happyReduce_86,
 happyReduce_87,
 happyReduce_88,
 happyReduce_89,
 happyReduce_90,
 happyReduce_91,
 happyReduce_92,
 happyReduce_93,
 happyReduce_94,
 happyReduce_95,
 happyReduce_96,
 happyReduce_97,
 happyReduce_98,
 happyReduce_99,
 happyReduce_100,
 happyReduce_101,
 happyReduce_102,
 happyReduce_103,
 happyReduce_104,
 happyReduce_105,
 happyReduce_106,
 happyReduce_107,
 happyReduce_108,
 happyReduce_109,
 happyReduce_110,
 happyReduce_111,
 happyReduce_112,
 happyReduce_113,
 happyReduce_114,
 happyReduce_115,
 happyReduce_116,
 happyReduce_117,
 happyReduce_118,
 happyReduce_119,
 happyReduce_120,
 happyReduce_121,
 happyReduce_122,
 happyReduce_123,
 happyReduce_124,
 happyReduce_125,
 happyReduce_126,
 happyReduce_127,
 happyReduce_128,
 happyReduce_129,
 happyReduce_130,
 happyReduce_131,
 happyReduce_132,
 happyReduce_133,
 happyReduce_134,
 happyReduce_135,
 happyReduce_136,
 happyReduce_137,
 happyReduce_138,
 happyReduce_139 :: () => ({-HappyReduction (IO) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (IO) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (IO) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (IO) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,678) ([0,49152,2103,165,23552,56,0,64,4096,16132,16,0,8192,0,33288,2079,0,0,16,1024,0,0,0,2048,0,0,0,0,0,4,0,0,0,0,19712,32512,354,64882,0,32768,6,1352,16384,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,256,0,0,64,0,0,0,256,0,0,0,32,0,0,0,0,8192,0,8,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,512,0,0,0,0,0,1,0,0,0,0,128,0,0,0,0,0,0,256,128,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,1,64,0,0,0,128,32768,0,0,0,0,0,16384,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,0,61505,259,0,0,8415,660,28672,225,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,256,0,0,0,0,0,0,4,0,0,32768,45373,0,0,0,0,0,0,0,0,57344,1,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,512,0,0,0,48640,10305,5,49888,1,0,8415,660,28672,225,0,256,0,64528,0,0,49152,2103,165,23552,56,0,7136,21124,0,7214,0,61440,49677,4143,7936,14,0,0,8192,0,0,0,0,0,2,0,0,0,0,256,0,0,0,0,32768,0,0,0,0,0,64,0,0,0,14272,42248,0,14428,0,57344,33819,82,11776,28,0,3568,10562,0,3607,0,0,0,3,0,0,0,0,384,0,0,0,0,49152,0,0,0,0,8415,660,28672,225,0,28544,18960,1,28856,0,49152,2103,165,23552,56,0,7136,21124,0,7214,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,50934,1030,0,0,256,0,0,0,0,32768,4207,330,47104,112,0,64,0,0,0,0,8192,0,0,0,0,0,16,0,0,0,0,4096,0,4,0,0,0,0,384,0,0,0,0,61440,704,0,0,0,8415,660,28672,225,0,32768,15744,177,0,0,0,0,24,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,57088,37920,2,57712,0,32768,4207,330,47104,112,0,14272,42248,0,14428,0,57344,33819,82,11776,28,0,3568,10562,0,3607,0,63488,41222,20,2944,7,0,33660,2640,49152,901,0,48640,10305,5,49888,1,0,8415,660,28672,225,0,28544,18960,1,28856,0,49152,2103,165,23552,56,0,64,4096,16132,16,0,0,0,0,32,0,0,0,5080,15,0,0,0,0,2048,16,0,0,0,512,0,0,0,512,32768,63520,129,0,0,0,0,0,0,0,128,8192,32264,32,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,4096,0,0,0,8,33280,2016,2,0,6656,8192,21,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,16640,1008,1,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,16,0,0,8,512,0,0,0,0,0,0,0,0,0,0,0,4,0,0,256,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,61440,16909,41,5888,14,0,0,0,8208,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,512,4,0,0,1,64,0,0,0,0,0,0,0,0,0,0,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,0,61505,259,0,0,0,0,0,0,0,256,16384,64528,64,0,0,0,0,0,0,0,0,3840,0,0,0,0,32768,7,0,0,0,0,960,0,0,0,0,60416,3481,2056,0,0,0,0,0,0,0,0,0,0,0,0,0,0,48,0,0,0,0,6144,0,0,0,0,0,11279,0,0,0,0,1920,22,0,0,0,0,8,0,0,0,0,36332,13,0,0,48640,10305,5,49888,1,0,8415,660,28672,225,0,0,15776,177,0,0,0,0,0,1,0,0,0,8192,0,0,0,0,0,16,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,32768,4207,330,47104,112,0,14272,42248,0,14428,0,0,0,0,0,0,0,0,4096,0,0,0,0,55296,6931,0,0,0,0,1024,0,0,0,0,62976,710,0,0,0,0,25467,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7128,11,0,0,0,0,0,0,0,0,0,50422,6,0,0,57088,37920,2,57712,0,32768,4207,330,47104,112,0,14272,42248,0,14428,0,57344,33819,82,11776,28,0,3568,10562,0,3607,0,63488,41222,20,2944,7,0,0,512,0,0,0,0,62980,708,0,0,0,32,25211,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,61440,16909,41,5888,14,0,1784,5281,32768,1803,0,31744,20611,10,34240,3,0,0,0,2056,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,32,0,0,0,0,4096,0,0,0,0,0,308,35324,51205,1013,0,0,62976,708,0,0,0,0,0,0,0,0,0,32768,0,0,0,49152,2103,165,23552,56,0,0,28512,44,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4160,16636,0,0,0,40640,89,0,0,0,24576,11471,0,0,0,0,26544,22,0,0,63488,41222,20,2944,7,0,33660,2640,49152,901,0,48640,10305,5,49888,1,0,0,25467,1,0,0,0,12288,0,0,0,0,0,24,0,0,0,0,3072,0,0,0,0,0,6,0,0,0,0,768,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31488,866,0,0,0,32768,45117,0,0,0,0,7872,88,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,256,0,0,0,0,0,0,0,128,0,0,64,0,0,0,0,0,0,16,0,0,0,0,0,8192,0,0,31744,20611,10,34240,3,0,0,50934,2,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pexc","%start_ptau","%start_ptaus","%start_ppat","%start_ppi","%start_pstr","%start_psigma","%start_pvalue","Sig","Sigma1","Sigma","Pats1","Pats","Pat","Qu","Ints1","Ints","Value","Str1","Str","Tau","Taus1","Taus","Pi1","Pi","Excs1","Excs","Exc","int","string","true","false","let","in","inc","if","then","else","split","as","null","case","of","'='","\"||\"","\"&&\"","not","'+'","'-'","'*'","'%'","'('","')'","'['","']'","'{'","'}'","'<'","\"<=\"","'>'","\"==\"","','","'.'","hi","su","un","\"un!\"","\"lo!\"","lo","':'","\"->\"","unit","p1","p2","id","'\\\\'","new","\"<-\"","upd","ent","den","isNull","head","tail","%eof"]
        bit_start = st * 87
        bit_end = (st + 1) * 87
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..86]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (31) = happyShift action_72
action_0 (32) = happyShift action_73
action_0 (33) = happyShift action_74
action_0 (34) = happyShift action_75
action_0 (35) = happyShift action_76
action_0 (37) = happyShift action_77
action_0 (38) = happyShift action_78
action_0 (44) = happyShift action_79
action_0 (49) = happyShift action_80
action_0 (51) = happyShift action_81
action_0 (54) = happyShift action_82
action_0 (56) = happyShift action_83
action_0 (75) = happyShift action_84
action_0 (76) = happyShift action_85
action_0 (77) = happyShift action_86
action_0 (79) = happyShift action_87
action_0 (84) = happyShift action_88
action_0 (85) = happyShift action_89
action_0 (86) = happyShift action_90
action_0 (30) = happyGoto action_71
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (32) = happyShift action_60
action_1 (54) = happyShift action_61
action_1 (60) = happyShift action_62
action_1 (66) = happyShift action_63
action_1 (67) = happyShift action_64
action_1 (68) = happyShift action_65
action_1 (69) = happyShift action_66
action_1 (70) = happyShift action_67
action_1 (71) = happyShift action_68
action_1 (78) = happyShift action_69
action_1 (17) = happyGoto action_56
action_1 (23) = happyGoto action_70
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (32) = happyShift action_60
action_2 (54) = happyShift action_61
action_2 (60) = happyShift action_62
action_2 (66) = happyShift action_63
action_2 (67) = happyShift action_64
action_2 (68) = happyShift action_65
action_2 (69) = happyShift action_66
action_2 (70) = happyShift action_67
action_2 (71) = happyShift action_68
action_2 (78) = happyShift action_69
action_2 (17) = happyGoto action_56
action_2 (23) = happyGoto action_57
action_2 (24) = happyGoto action_58
action_2 (25) = happyGoto action_59
action_2 _ = happyReduce_84

action_3 (32) = happyShift action_54
action_3 (54) = happyShift action_55
action_3 (16) = happyGoto action_53
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (32) = happyShift action_52
action_4 (26) = happyGoto action_50
action_4 (27) = happyGoto action_51
action_4 _ = happyReduce_88

action_5 (32) = happyShift action_49
action_5 (21) = happyGoto action_47
action_5 (22) = happyGoto action_48
action_5 _ = happyReduce_73

action_6 (31) = happyShift action_22
action_6 (33) = happyShift action_9
action_6 (34) = happyShift action_23
action_6 (37) = happyShift action_24
action_6 (47) = happyShift action_25
action_6 (48) = happyShift action_26
action_6 (49) = happyShift action_27
action_6 (50) = happyShift action_28
action_6 (51) = happyShift action_29
action_6 (52) = happyShift action_30
action_6 (53) = happyShift action_31
action_6 (56) = happyShift action_32
action_6 (60) = happyShift action_33
action_6 (61) = happyShift action_34
action_6 (63) = happyShift action_35
action_6 (72) = happyShift action_36
action_6 (75) = happyShift action_37
action_6 (76) = happyShift action_38
action_6 (77) = happyShift action_39
action_6 (79) = happyShift action_40
action_6 (81) = happyShift action_41
action_6 (82) = happyShift action_42
action_6 (83) = happyShift action_43
action_6 (84) = happyShift action_44
action_6 (85) = happyShift action_45
action_6 (86) = happyShift action_46
action_6 (11) = happyGoto action_19
action_6 (12) = happyGoto action_20
action_6 (13) = happyGoto action_21
action_6 _ = happyReduce_42

action_7 (31) = happyShift action_11
action_7 (33) = happyShift action_12
action_7 (34) = happyShift action_13
action_7 (51) = happyShift action_14
action_7 (54) = happyShift action_15
action_7 (56) = happyShift action_16
action_7 (58) = happyShift action_17
action_7 (78) = happyShift action_18
action_7 (20) = happyGoto action_10
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (33) = happyShift action_9
action_8 _ = happyFail (happyExpListPerState 8)

action_9 _ = happyReduce_8

action_10 (87) = happyAccept
action_10 _ = happyFail (happyExpListPerState 10)

action_11 _ = happyReduce_64

action_12 _ = happyReduce_62

action_13 _ = happyReduce_63

action_14 (31) = happyShift action_157
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (32) = happyShift action_155
action_15 (78) = happyShift action_156
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (57) = happyShift action_154
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (31) = happyShift action_153
action_17 (18) = happyGoto action_151
action_17 (19) = happyGoto action_152
action_17 _ = happyReduce_60

action_18 (32) = happyShift action_54
action_18 (54) = happyShift action_55
action_18 (16) = happyGoto action_150
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (72) = happyShift action_149
action_19 _ = happyFail (happyExpListPerState 19)

action_20 _ = happyReduce_43

action_21 (87) = happyAccept
action_21 _ = happyFail (happyExpListPerState 21)

action_22 _ = happyReduce_10

action_23 _ = happyReduce_9

action_24 _ = happyReduce_22

action_25 _ = happyReduce_13

action_26 _ = happyReduce_12

action_27 _ = happyReduce_11

action_28 (31) = happyShift action_148
action_28 _ = happyReduce_17

action_29 (31) = happyShift action_147
action_29 _ = happyReduce_18

action_30 (31) = happyShift action_146
action_30 _ = happyReduce_19

action_31 (31) = happyShift action_145
action_31 _ = happyReduce_20

action_32 (57) = happyShift action_143
action_32 (72) = happyShift action_144
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_16

action_34 _ = happyReduce_15

action_35 (31) = happyShift action_142
action_35 _ = happyReduce_14

action_36 _ = happyReduce_34

action_37 _ = happyReduce_27

action_38 _ = happyReduce_28

action_39 _ = happyReduce_26

action_40 _ = happyReduce_21

action_41 _ = happyReduce_23

action_42 _ = happyReduce_24

action_43 _ = happyReduce_25

action_44 _ = happyReduce_37

action_45 _ = happyReduce_38

action_46 _ = happyReduce_39

action_47 _ = happyReduce_74

action_48 (87) = happyAccept
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (46) = happyShift action_141
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_89

action_51 (87) = happyAccept
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (72) = happyShift action_140
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (87) = happyAccept
action_53 _ = happyFail (happyExpListPerState 53)

action_54 _ = happyReduce_48

action_55 (32) = happyShift action_54
action_55 (54) = happyShift action_55
action_55 (14) = happyGoto action_137
action_55 (15) = happyGoto action_138
action_55 (16) = happyGoto action_139
action_55 _ = happyReduce_46

action_56 (32) = happyShift action_135
action_56 (56) = happyShift action_136
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (64) = happyShift action_134
action_57 (73) = happyShift action_129
action_57 _ = happyReduce_82

action_58 _ = happyReduce_85

action_59 (87) = happyAccept
action_59 _ = happyFail (happyExpListPerState 59)

action_60 _ = happyReduce_56

action_61 (32) = happyShift action_60
action_61 (54) = happyShift action_61
action_61 (60) = happyShift action_62
action_61 (66) = happyShift action_63
action_61 (67) = happyShift action_64
action_61 (68) = happyShift action_65
action_61 (69) = happyShift action_66
action_61 (70) = happyShift action_67
action_61 (71) = happyShift action_68
action_61 (78) = happyShift action_69
action_61 (17) = happyGoto action_56
action_61 (23) = happyGoto action_132
action_61 (24) = happyGoto action_58
action_61 (25) = happyGoto action_133
action_61 _ = happyReduce_84

action_62 (31) = happyShift action_72
action_62 (32) = happyShift action_73
action_62 (33) = happyShift action_74
action_62 (34) = happyShift action_75
action_62 (35) = happyShift action_76
action_62 (37) = happyShift action_77
action_62 (38) = happyShift action_78
action_62 (44) = happyShift action_79
action_62 (49) = happyShift action_80
action_62 (51) = happyShift action_81
action_62 (54) = happyShift action_82
action_62 (56) = happyShift action_83
action_62 (75) = happyShift action_84
action_62 (76) = happyShift action_85
action_62 (77) = happyShift action_86
action_62 (79) = happyShift action_87
action_62 (84) = happyShift action_88
action_62 (85) = happyShift action_89
action_62 (86) = happyShift action_90
action_62 (30) = happyGoto action_131
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_54

action_64 _ = happyReduce_53

action_65 _ = happyReduce_50

action_66 _ = happyReduce_51

action_67 _ = happyReduce_52

action_68 _ = happyReduce_55

action_69 (32) = happyShift action_54
action_69 (54) = happyShift action_55
action_69 (16) = happyGoto action_130
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (73) = happyShift action_129
action_70 (87) = happyAccept
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (47) = happyShift action_119
action_71 (48) = happyShift action_120
action_71 (50) = happyShift action_121
action_71 (51) = happyShift action_122
action_71 (52) = happyShift action_123
action_71 (53) = happyShift action_124
action_71 (56) = happyShift action_125
action_71 (60) = happyShift action_126
action_71 (61) = happyShift action_127
action_71 (63) = happyShift action_128
action_71 (87) = happyAccept
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_95

action_73 (31) = happyShift action_114
action_73 (32) = happyShift action_115
action_73 (33) = happyShift action_116
action_73 (34) = happyShift action_117
action_73 (54) = happyShift action_118
action_73 _ = happyReduce_94

action_74 _ = happyReduce_96

action_75 _ = happyReduce_97

action_76 (32) = happyShift action_54
action_76 (54) = happyShift action_55
action_76 (16) = happyGoto action_113
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (31) = happyShift action_72
action_77 (32) = happyShift action_73
action_77 (33) = happyShift action_74
action_77 (34) = happyShift action_75
action_77 (35) = happyShift action_76
action_77 (37) = happyShift action_77
action_77 (38) = happyShift action_78
action_77 (44) = happyShift action_79
action_77 (49) = happyShift action_80
action_77 (51) = happyShift action_81
action_77 (54) = happyShift action_82
action_77 (56) = happyShift action_83
action_77 (75) = happyShift action_84
action_77 (76) = happyShift action_85
action_77 (77) = happyShift action_86
action_77 (79) = happyShift action_87
action_77 (84) = happyShift action_88
action_77 (85) = happyShift action_89
action_77 (86) = happyShift action_90
action_77 (30) = happyGoto action_112
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (31) = happyShift action_72
action_78 (32) = happyShift action_73
action_78 (33) = happyShift action_74
action_78 (34) = happyShift action_75
action_78 (35) = happyShift action_76
action_78 (37) = happyShift action_77
action_78 (38) = happyShift action_78
action_78 (44) = happyShift action_79
action_78 (49) = happyShift action_80
action_78 (51) = happyShift action_81
action_78 (54) = happyShift action_82
action_78 (56) = happyShift action_83
action_78 (75) = happyShift action_84
action_78 (76) = happyShift action_85
action_78 (77) = happyShift action_86
action_78 (79) = happyShift action_87
action_78 (84) = happyShift action_88
action_78 (85) = happyShift action_89
action_78 (86) = happyShift action_90
action_78 (30) = happyGoto action_111
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (32) = happyShift action_60
action_79 (60) = happyShift action_62
action_79 (66) = happyShift action_63
action_79 (67) = happyShift action_64
action_79 (68) = happyShift action_65
action_79 (69) = happyShift action_66
action_79 (70) = happyShift action_67
action_79 (71) = happyShift action_68
action_79 (17) = happyGoto action_110
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (31) = happyShift action_72
action_80 (32) = happyShift action_73
action_80 (33) = happyShift action_74
action_80 (34) = happyShift action_75
action_80 (35) = happyShift action_76
action_80 (37) = happyShift action_77
action_80 (38) = happyShift action_78
action_80 (44) = happyShift action_79
action_80 (49) = happyShift action_80
action_80 (51) = happyShift action_81
action_80 (54) = happyShift action_82
action_80 (56) = happyShift action_83
action_80 (75) = happyShift action_84
action_80 (76) = happyShift action_85
action_80 (77) = happyShift action_86
action_80 (79) = happyShift action_87
action_80 (84) = happyShift action_88
action_80 (85) = happyShift action_89
action_80 (86) = happyShift action_90
action_80 (30) = happyGoto action_109
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (31) = happyShift action_72
action_81 (32) = happyShift action_73
action_81 (33) = happyShift action_74
action_81 (34) = happyShift action_75
action_81 (35) = happyShift action_76
action_81 (37) = happyShift action_77
action_81 (38) = happyShift action_78
action_81 (44) = happyShift action_79
action_81 (49) = happyShift action_80
action_81 (51) = happyShift action_81
action_81 (54) = happyShift action_82
action_81 (56) = happyShift action_83
action_81 (75) = happyShift action_84
action_81 (76) = happyShift action_85
action_81 (77) = happyShift action_86
action_81 (79) = happyShift action_87
action_81 (84) = happyShift action_88
action_81 (85) = happyShift action_89
action_81 (86) = happyShift action_90
action_81 (30) = happyGoto action_108
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (31) = happyShift action_72
action_82 (32) = happyShift action_73
action_82 (33) = happyShift action_74
action_82 (34) = happyShift action_75
action_82 (35) = happyShift action_76
action_82 (37) = happyShift action_77
action_82 (38) = happyShift action_78
action_82 (44) = happyShift action_79
action_82 (49) = happyShift action_80
action_82 (50) = happyShift action_102
action_82 (51) = happyShift action_103
action_82 (52) = happyShift action_104
action_82 (53) = happyShift action_105
action_82 (54) = happyShift action_82
action_82 (56) = happyShift action_83
action_82 (63) = happyShift action_106
action_82 (75) = happyShift action_84
action_82 (76) = happyShift action_85
action_82 (77) = happyShift action_86
action_82 (78) = happyShift action_107
action_82 (79) = happyShift action_87
action_82 (84) = happyShift action_88
action_82 (85) = happyShift action_89
action_82 (86) = happyShift action_90
action_82 (28) = happyGoto action_99
action_82 (29) = happyGoto action_100
action_82 (30) = happyGoto action_101
action_82 _ = happyReduce_92

action_83 (57) = happyShift action_98
action_83 _ = happyFail (happyExpListPerState 83)

action_84 (54) = happyShift action_97
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (54) = happyShift action_96
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (54) = happyShift action_95
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (54) = happyShift action_94
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (31) = happyShift action_72
action_88 (32) = happyShift action_73
action_88 (33) = happyShift action_74
action_88 (34) = happyShift action_75
action_88 (35) = happyShift action_76
action_88 (37) = happyShift action_77
action_88 (38) = happyShift action_78
action_88 (44) = happyShift action_79
action_88 (49) = happyShift action_80
action_88 (51) = happyShift action_81
action_88 (54) = happyShift action_82
action_88 (56) = happyShift action_83
action_88 (75) = happyShift action_84
action_88 (76) = happyShift action_85
action_88 (77) = happyShift action_86
action_88 (79) = happyShift action_87
action_88 (84) = happyShift action_88
action_88 (85) = happyShift action_89
action_88 (86) = happyShift action_90
action_88 (30) = happyGoto action_93
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (31) = happyShift action_72
action_89 (32) = happyShift action_73
action_89 (33) = happyShift action_74
action_89 (34) = happyShift action_75
action_89 (35) = happyShift action_76
action_89 (37) = happyShift action_77
action_89 (38) = happyShift action_78
action_89 (44) = happyShift action_79
action_89 (49) = happyShift action_80
action_89 (51) = happyShift action_81
action_89 (54) = happyShift action_82
action_89 (56) = happyShift action_83
action_89 (75) = happyShift action_84
action_89 (76) = happyShift action_85
action_89 (77) = happyShift action_86
action_89 (79) = happyShift action_87
action_89 (84) = happyShift action_88
action_89 (85) = happyShift action_89
action_89 (86) = happyShift action_90
action_89 (30) = happyGoto action_92
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (31) = happyShift action_72
action_90 (32) = happyShift action_73
action_90 (33) = happyShift action_74
action_90 (34) = happyShift action_75
action_90 (35) = happyShift action_76
action_90 (37) = happyShift action_77
action_90 (38) = happyShift action_78
action_90 (44) = happyShift action_79
action_90 (49) = happyShift action_80
action_90 (51) = happyShift action_81
action_90 (54) = happyShift action_82
action_90 (56) = happyShift action_83
action_90 (75) = happyShift action_84
action_90 (76) = happyShift action_85
action_90 (77) = happyShift action_86
action_90 (79) = happyShift action_87
action_90 (84) = happyShift action_88
action_90 (85) = happyShift action_89
action_90 (86) = happyShift action_90
action_90 (30) = happyGoto action_91
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (52) = happyShift action_123
action_91 (53) = happyShift action_124
action_91 (56) = happyShift action_125
action_91 _ = happyReduce_138

action_92 (52) = happyShift action_123
action_92 (53) = happyShift action_124
action_92 (56) = happyShift action_125
action_92 _ = happyReduce_137

action_93 (52) = happyShift action_123
action_93 (53) = happyShift action_124
action_93 (56) = happyShift action_125
action_93 _ = happyReduce_139

action_94 (31) = happyShift action_72
action_94 (32) = happyShift action_73
action_94 (33) = happyShift action_74
action_94 (34) = happyShift action_75
action_94 (35) = happyShift action_76
action_94 (37) = happyShift action_77
action_94 (38) = happyShift action_78
action_94 (44) = happyShift action_79
action_94 (49) = happyShift action_80
action_94 (51) = happyShift action_81
action_94 (54) = happyShift action_82
action_94 (56) = happyShift action_83
action_94 (75) = happyShift action_84
action_94 (76) = happyShift action_85
action_94 (77) = happyShift action_86
action_94 (79) = happyShift action_87
action_94 (84) = happyShift action_88
action_94 (85) = happyShift action_89
action_94 (86) = happyShift action_90
action_94 (30) = happyGoto action_206
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (31) = happyShift action_72
action_95 (32) = happyShift action_73
action_95 (33) = happyShift action_74
action_95 (34) = happyShift action_75
action_95 (35) = happyShift action_76
action_95 (37) = happyShift action_77
action_95 (38) = happyShift action_78
action_95 (44) = happyShift action_79
action_95 (49) = happyShift action_80
action_95 (51) = happyShift action_81
action_95 (54) = happyShift action_82
action_95 (56) = happyShift action_83
action_95 (75) = happyShift action_84
action_95 (76) = happyShift action_85
action_95 (77) = happyShift action_86
action_95 (79) = happyShift action_87
action_95 (84) = happyShift action_88
action_95 (85) = happyShift action_89
action_95 (86) = happyShift action_90
action_95 (30) = happyGoto action_205
action_95 _ = happyFail (happyExpListPerState 95)

action_96 (31) = happyShift action_72
action_96 (32) = happyShift action_73
action_96 (33) = happyShift action_74
action_96 (34) = happyShift action_75
action_96 (35) = happyShift action_76
action_96 (37) = happyShift action_77
action_96 (38) = happyShift action_78
action_96 (44) = happyShift action_79
action_96 (49) = happyShift action_80
action_96 (51) = happyShift action_81
action_96 (54) = happyShift action_82
action_96 (56) = happyShift action_83
action_96 (75) = happyShift action_84
action_96 (76) = happyShift action_85
action_96 (77) = happyShift action_86
action_96 (79) = happyShift action_87
action_96 (84) = happyShift action_88
action_96 (85) = happyShift action_89
action_96 (86) = happyShift action_90
action_96 (28) = happyGoto action_99
action_96 (29) = happyGoto action_204
action_96 (30) = happyGoto action_203
action_96 _ = happyReduce_92

action_97 (31) = happyShift action_72
action_97 (32) = happyShift action_73
action_97 (33) = happyShift action_74
action_97 (34) = happyShift action_75
action_97 (35) = happyShift action_76
action_97 (37) = happyShift action_77
action_97 (38) = happyShift action_78
action_97 (44) = happyShift action_79
action_97 (49) = happyShift action_80
action_97 (51) = happyShift action_81
action_97 (54) = happyShift action_82
action_97 (56) = happyShift action_83
action_97 (75) = happyShift action_84
action_97 (76) = happyShift action_85
action_97 (77) = happyShift action_86
action_97 (79) = happyShift action_87
action_97 (84) = happyShift action_88
action_97 (85) = happyShift action_89
action_97 (86) = happyShift action_90
action_97 (28) = happyGoto action_99
action_97 (29) = happyGoto action_202
action_97 (30) = happyGoto action_203
action_97 _ = happyReduce_92

action_98 _ = happyReduce_135

action_99 _ = happyReduce_93

action_100 (55) = happyShift action_201
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (47) = happyShift action_119
action_101 (48) = happyShift action_120
action_101 (50) = happyShift action_121
action_101 (51) = happyShift action_122
action_101 (52) = happyShift action_123
action_101 (53) = happyShift action_124
action_101 (55) = happyShift action_198
action_101 (56) = happyShift action_125
action_101 (60) = happyShift action_126
action_101 (61) = happyShift action_127
action_101 (63) = happyShift action_128
action_101 (64) = happyShift action_199
action_101 (72) = happyShift action_200
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (31) = happyShift action_197
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (31) = happyShift action_196
action_103 (32) = happyShift action_73
action_103 (33) = happyShift action_74
action_103 (34) = happyShift action_75
action_103 (35) = happyShift action_76
action_103 (37) = happyShift action_77
action_103 (38) = happyShift action_78
action_103 (44) = happyShift action_79
action_103 (49) = happyShift action_80
action_103 (51) = happyShift action_81
action_103 (54) = happyShift action_82
action_103 (56) = happyShift action_83
action_103 (75) = happyShift action_84
action_103 (76) = happyShift action_85
action_103 (77) = happyShift action_86
action_103 (79) = happyShift action_87
action_103 (84) = happyShift action_88
action_103 (85) = happyShift action_89
action_103 (86) = happyShift action_90
action_103 (30) = happyGoto action_108
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (31) = happyShift action_195
action_104 _ = happyFail (happyExpListPerState 104)

action_105 (31) = happyShift action_194
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (31) = happyShift action_193
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (32) = happyShift action_54
action_107 (54) = happyShift action_55
action_107 (16) = happyGoto action_192
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (52) = happyShift action_123
action_108 (53) = happyShift action_124
action_108 (56) = happyShift action_125
action_108 _ = happyReduce_100

action_109 (50) = happyShift action_121
action_109 (51) = happyShift action_122
action_109 (52) = happyShift action_123
action_109 (53) = happyShift action_124
action_109 (56) = happyShift action_125
action_109 (60) = happyShift action_126
action_109 (61) = happyShift action_127
action_109 (63) = happyShift action_128
action_109 _ = happyReduce_98

action_110 (31) = happyShift action_72
action_110 (32) = happyShift action_73
action_110 (33) = happyShift action_74
action_110 (34) = happyShift action_75
action_110 (35) = happyShift action_76
action_110 (37) = happyShift action_77
action_110 (38) = happyShift action_78
action_110 (44) = happyShift action_79
action_110 (49) = happyShift action_80
action_110 (51) = happyShift action_81
action_110 (54) = happyShift action_82
action_110 (56) = happyShift action_83
action_110 (75) = happyShift action_84
action_110 (76) = happyShift action_85
action_110 (77) = happyShift action_86
action_110 (79) = happyShift action_87
action_110 (84) = happyShift action_88
action_110 (85) = happyShift action_89
action_110 (86) = happyShift action_90
action_110 (30) = happyGoto action_191
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (39) = happyShift action_190
action_111 (47) = happyShift action_119
action_111 (48) = happyShift action_120
action_111 (50) = happyShift action_121
action_111 (51) = happyShift action_122
action_111 (52) = happyShift action_123
action_111 (53) = happyShift action_124
action_111 (56) = happyShift action_125
action_111 (60) = happyShift action_126
action_111 (61) = happyShift action_127
action_111 (63) = happyShift action_128
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (52) = happyShift action_123
action_112 (53) = happyShift action_124
action_112 (56) = happyShift action_125
action_112 _ = happyReduce_99

action_113 (46) = happyShift action_189
action_113 _ = happyFail (happyExpListPerState 113)

action_114 _ = happyReduce_125

action_115 _ = happyReduce_126

action_116 _ = happyReduce_127

action_117 _ = happyReduce_128

action_118 (31) = happyShift action_72
action_118 (32) = happyShift action_73
action_118 (33) = happyShift action_74
action_118 (34) = happyShift action_75
action_118 (35) = happyShift action_76
action_118 (37) = happyShift action_77
action_118 (38) = happyShift action_78
action_118 (44) = happyShift action_79
action_118 (49) = happyShift action_80
action_118 (51) = happyShift action_81
action_118 (54) = happyShift action_82
action_118 (56) = happyShift action_83
action_118 (75) = happyShift action_84
action_118 (76) = happyShift action_85
action_118 (77) = happyShift action_86
action_118 (79) = happyShift action_87
action_118 (84) = happyShift action_88
action_118 (85) = happyShift action_89
action_118 (86) = happyShift action_90
action_118 (28) = happyGoto action_187
action_118 (30) = happyGoto action_188
action_118 _ = happyFail (happyExpListPerState 118)

action_119 (31) = happyShift action_72
action_119 (32) = happyShift action_73
action_119 (33) = happyShift action_74
action_119 (34) = happyShift action_75
action_119 (35) = happyShift action_76
action_119 (37) = happyShift action_77
action_119 (38) = happyShift action_78
action_119 (44) = happyShift action_79
action_119 (49) = happyShift action_80
action_119 (51) = happyShift action_81
action_119 (54) = happyShift action_82
action_119 (56) = happyShift action_83
action_119 (75) = happyShift action_84
action_119 (76) = happyShift action_85
action_119 (77) = happyShift action_86
action_119 (79) = happyShift action_87
action_119 (84) = happyShift action_88
action_119 (85) = happyShift action_89
action_119 (86) = happyShift action_90
action_119 (30) = happyGoto action_186
action_119 _ = happyFail (happyExpListPerState 119)

action_120 (31) = happyShift action_72
action_120 (32) = happyShift action_73
action_120 (33) = happyShift action_74
action_120 (34) = happyShift action_75
action_120 (35) = happyShift action_76
action_120 (37) = happyShift action_77
action_120 (38) = happyShift action_78
action_120 (44) = happyShift action_79
action_120 (49) = happyShift action_80
action_120 (51) = happyShift action_81
action_120 (54) = happyShift action_82
action_120 (56) = happyShift action_83
action_120 (75) = happyShift action_84
action_120 (76) = happyShift action_85
action_120 (77) = happyShift action_86
action_120 (79) = happyShift action_87
action_120 (84) = happyShift action_88
action_120 (85) = happyShift action_89
action_120 (86) = happyShift action_90
action_120 (30) = happyGoto action_185
action_120 _ = happyFail (happyExpListPerState 120)

action_121 (31) = happyShift action_72
action_121 (32) = happyShift action_73
action_121 (33) = happyShift action_74
action_121 (34) = happyShift action_75
action_121 (35) = happyShift action_76
action_121 (37) = happyShift action_77
action_121 (38) = happyShift action_78
action_121 (44) = happyShift action_79
action_121 (49) = happyShift action_80
action_121 (51) = happyShift action_81
action_121 (54) = happyShift action_82
action_121 (56) = happyShift action_83
action_121 (75) = happyShift action_84
action_121 (76) = happyShift action_85
action_121 (77) = happyShift action_86
action_121 (79) = happyShift action_87
action_121 (84) = happyShift action_88
action_121 (85) = happyShift action_89
action_121 (86) = happyShift action_90
action_121 (30) = happyGoto action_184
action_121 _ = happyFail (happyExpListPerState 121)

action_122 (31) = happyShift action_72
action_122 (32) = happyShift action_73
action_122 (33) = happyShift action_74
action_122 (34) = happyShift action_75
action_122 (35) = happyShift action_76
action_122 (37) = happyShift action_77
action_122 (38) = happyShift action_78
action_122 (44) = happyShift action_79
action_122 (49) = happyShift action_80
action_122 (51) = happyShift action_81
action_122 (54) = happyShift action_82
action_122 (56) = happyShift action_83
action_122 (75) = happyShift action_84
action_122 (76) = happyShift action_85
action_122 (77) = happyShift action_86
action_122 (79) = happyShift action_87
action_122 (84) = happyShift action_88
action_122 (85) = happyShift action_89
action_122 (86) = happyShift action_90
action_122 (30) = happyGoto action_183
action_122 _ = happyFail (happyExpListPerState 122)

action_123 (31) = happyShift action_72
action_123 (32) = happyShift action_73
action_123 (33) = happyShift action_74
action_123 (34) = happyShift action_75
action_123 (35) = happyShift action_76
action_123 (37) = happyShift action_77
action_123 (38) = happyShift action_78
action_123 (44) = happyShift action_79
action_123 (49) = happyShift action_80
action_123 (51) = happyShift action_81
action_123 (54) = happyShift action_82
action_123 (56) = happyShift action_83
action_123 (75) = happyShift action_84
action_123 (76) = happyShift action_85
action_123 (77) = happyShift action_86
action_123 (79) = happyShift action_87
action_123 (84) = happyShift action_88
action_123 (85) = happyShift action_89
action_123 (86) = happyShift action_90
action_123 (30) = happyGoto action_182
action_123 _ = happyFail (happyExpListPerState 123)

action_124 (31) = happyShift action_72
action_124 (32) = happyShift action_73
action_124 (33) = happyShift action_74
action_124 (34) = happyShift action_75
action_124 (35) = happyShift action_76
action_124 (37) = happyShift action_77
action_124 (38) = happyShift action_78
action_124 (44) = happyShift action_79
action_124 (49) = happyShift action_80
action_124 (51) = happyShift action_81
action_124 (54) = happyShift action_82
action_124 (56) = happyShift action_83
action_124 (75) = happyShift action_84
action_124 (76) = happyShift action_85
action_124 (77) = happyShift action_86
action_124 (79) = happyShift action_87
action_124 (84) = happyShift action_88
action_124 (85) = happyShift action_89
action_124 (86) = happyShift action_90
action_124 (30) = happyGoto action_181
action_124 _ = happyFail (happyExpListPerState 124)

action_125 (31) = happyShift action_72
action_125 (32) = happyShift action_73
action_125 (33) = happyShift action_74
action_125 (34) = happyShift action_75
action_125 (35) = happyShift action_76
action_125 (37) = happyShift action_77
action_125 (38) = happyShift action_78
action_125 (44) = happyShift action_79
action_125 (49) = happyShift action_80
action_125 (51) = happyShift action_81
action_125 (54) = happyShift action_82
action_125 (56) = happyShift action_83
action_125 (75) = happyShift action_84
action_125 (76) = happyShift action_85
action_125 (77) = happyShift action_86
action_125 (79) = happyShift action_87
action_125 (84) = happyShift action_88
action_125 (85) = happyShift action_89
action_125 (86) = happyShift action_90
action_125 (30) = happyGoto action_180
action_125 _ = happyFail (happyExpListPerState 125)

action_126 (31) = happyShift action_72
action_126 (32) = happyShift action_73
action_126 (33) = happyShift action_74
action_126 (34) = happyShift action_75
action_126 (35) = happyShift action_76
action_126 (37) = happyShift action_77
action_126 (38) = happyShift action_78
action_126 (44) = happyShift action_79
action_126 (49) = happyShift action_80
action_126 (51) = happyShift action_81
action_126 (54) = happyShift action_82
action_126 (56) = happyShift action_83
action_126 (75) = happyShift action_84
action_126 (76) = happyShift action_85
action_126 (77) = happyShift action_86
action_126 (79) = happyShift action_87
action_126 (84) = happyShift action_88
action_126 (85) = happyShift action_89
action_126 (86) = happyShift action_90
action_126 (30) = happyGoto action_179
action_126 _ = happyFail (happyExpListPerState 126)

action_127 (31) = happyShift action_72
action_127 (32) = happyShift action_73
action_127 (33) = happyShift action_74
action_127 (34) = happyShift action_75
action_127 (35) = happyShift action_76
action_127 (37) = happyShift action_77
action_127 (38) = happyShift action_78
action_127 (44) = happyShift action_79
action_127 (49) = happyShift action_80
action_127 (51) = happyShift action_81
action_127 (54) = happyShift action_82
action_127 (56) = happyShift action_83
action_127 (75) = happyShift action_84
action_127 (76) = happyShift action_85
action_127 (77) = happyShift action_86
action_127 (79) = happyShift action_87
action_127 (84) = happyShift action_88
action_127 (85) = happyShift action_89
action_127 (86) = happyShift action_90
action_127 (30) = happyGoto action_178
action_127 _ = happyFail (happyExpListPerState 127)

action_128 (31) = happyShift action_72
action_128 (32) = happyShift action_73
action_128 (33) = happyShift action_74
action_128 (34) = happyShift action_75
action_128 (35) = happyShift action_76
action_128 (37) = happyShift action_77
action_128 (38) = happyShift action_78
action_128 (44) = happyShift action_79
action_128 (49) = happyShift action_80
action_128 (51) = happyShift action_81
action_128 (54) = happyShift action_82
action_128 (56) = happyShift action_83
action_128 (75) = happyShift action_84
action_128 (76) = happyShift action_85
action_128 (77) = happyShift action_86
action_128 (79) = happyShift action_87
action_128 (84) = happyShift action_88
action_128 (85) = happyShift action_89
action_128 (86) = happyShift action_90
action_128 (30) = happyGoto action_177
action_128 _ = happyFail (happyExpListPerState 128)

action_129 (32) = happyShift action_60
action_129 (54) = happyShift action_61
action_129 (60) = happyShift action_62
action_129 (66) = happyShift action_63
action_129 (67) = happyShift action_64
action_129 (68) = happyShift action_65
action_129 (69) = happyShift action_66
action_129 (70) = happyShift action_67
action_129 (71) = happyShift action_68
action_129 (78) = happyShift action_69
action_129 (17) = happyGoto action_56
action_129 (23) = happyGoto action_176
action_129 _ = happyFail (happyExpListPerState 129)

action_130 (72) = happyShift action_175
action_130 _ = happyFail (happyExpListPerState 130)

action_131 (47) = happyShift action_119
action_131 (48) = happyShift action_120
action_131 (50) = happyShift action_121
action_131 (51) = happyShift action_122
action_131 (52) = happyShift action_123
action_131 (53) = happyShift action_124
action_131 (56) = happyShift action_125
action_131 (60) = happyShift action_126
action_131 (61) = happyShift action_127
action_131 (62) = happyShift action_174
action_131 (63) = happyShift action_128
action_131 _ = happyFail (happyExpListPerState 131)

action_132 (55) = happyShift action_172
action_132 (64) = happyShift action_134
action_132 (73) = happyShift action_173
action_132 _ = happyFail (happyExpListPerState 132)

action_133 (55) = happyShift action_171
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (32) = happyShift action_60
action_134 (54) = happyShift action_61
action_134 (60) = happyShift action_62
action_134 (66) = happyShift action_63
action_134 (67) = happyShift action_64
action_134 (68) = happyShift action_65
action_134 (69) = happyShift action_66
action_134 (70) = happyShift action_67
action_134 (71) = happyShift action_68
action_134 (78) = happyShift action_69
action_134 (17) = happyGoto action_56
action_134 (23) = happyGoto action_57
action_134 (24) = happyGoto action_170
action_134 _ = happyFail (happyExpListPerState 134)

action_135 _ = happyReduce_75

action_136 (32) = happyShift action_60
action_136 (54) = happyShift action_61
action_136 (60) = happyShift action_62
action_136 (66) = happyShift action_63
action_136 (67) = happyShift action_64
action_136 (68) = happyShift action_65
action_136 (69) = happyShift action_66
action_136 (70) = happyShift action_67
action_136 (71) = happyShift action_68
action_136 (78) = happyShift action_69
action_136 (17) = happyGoto action_56
action_136 (23) = happyGoto action_169
action_136 _ = happyFail (happyExpListPerState 136)

action_137 _ = happyReduce_47

action_138 (55) = happyShift action_168
action_138 _ = happyFail (happyExpListPerState 138)

action_139 (64) = happyShift action_167
action_139 _ = happyFail (happyExpListPerState 139)

action_140 (32) = happyShift action_60
action_140 (54) = happyShift action_61
action_140 (60) = happyShift action_62
action_140 (66) = happyShift action_63
action_140 (67) = happyShift action_64
action_140 (68) = happyShift action_65
action_140 (69) = happyShift action_66
action_140 (70) = happyShift action_67
action_140 (71) = happyShift action_68
action_140 (78) = happyShift action_69
action_140 (17) = happyGoto action_56
action_140 (23) = happyGoto action_166
action_140 _ = happyFail (happyExpListPerState 140)

action_141 (31) = happyShift action_11
action_141 (33) = happyShift action_12
action_141 (34) = happyShift action_13
action_141 (51) = happyShift action_14
action_141 (54) = happyShift action_15
action_141 (56) = happyShift action_16
action_141 (58) = happyShift action_17
action_141 (78) = happyShift action_18
action_141 (20) = happyGoto action_165
action_141 _ = happyFail (happyExpListPerState 141)

action_142 _ = happyReduce_29

action_143 _ = happyReduce_35

action_144 (57) = happyShift action_164
action_144 _ = happyFail (happyExpListPerState 144)

action_145 _ = happyReduce_32

action_146 _ = happyReduce_33

action_147 _ = happyReduce_31

action_148 _ = happyReduce_30

action_149 (32) = happyShift action_60
action_149 (54) = happyShift action_61
action_149 (60) = happyShift action_62
action_149 (66) = happyShift action_63
action_149 (67) = happyShift action_64
action_149 (68) = happyShift action_65
action_149 (69) = happyShift action_66
action_149 (70) = happyShift action_67
action_149 (71) = happyShift action_68
action_149 (78) = happyShift action_69
action_149 (17) = happyGoto action_56
action_149 (23) = happyGoto action_163
action_149 _ = happyFail (happyExpListPerState 149)

action_150 (65) = happyShift action_162
action_150 _ = happyFail (happyExpListPerState 150)

action_151 _ = happyReduce_61

action_152 (59) = happyShift action_161
action_152 _ = happyFail (happyExpListPerState 152)

action_153 (64) = happyShift action_160
action_153 _ = happyReduce_58

action_154 _ = happyReduce_70

action_155 (72) = happyShift action_159
action_155 _ = happyFail (happyExpListPerState 155)

action_156 (32) = happyShift action_54
action_156 (54) = happyShift action_55
action_156 (16) = happyGoto action_158
action_156 _ = happyFail (happyExpListPerState 156)

action_157 _ = happyReduce_65

action_158 (65) = happyShift action_240
action_158 _ = happyFail (happyExpListPerState 158)

action_159 (32) = happyShift action_239
action_159 _ = happyFail (happyExpListPerState 159)

action_160 (31) = happyShift action_153
action_160 (18) = happyGoto action_238
action_160 _ = happyFail (happyExpListPerState 160)

action_161 _ = happyReduce_68

action_162 (31) = happyShift action_72
action_162 (32) = happyShift action_73
action_162 (33) = happyShift action_74
action_162 (34) = happyShift action_75
action_162 (35) = happyShift action_76
action_162 (37) = happyShift action_77
action_162 (38) = happyShift action_78
action_162 (44) = happyShift action_79
action_162 (49) = happyShift action_80
action_162 (51) = happyShift action_81
action_162 (54) = happyShift action_82
action_162 (56) = happyShift action_83
action_162 (75) = happyShift action_84
action_162 (76) = happyShift action_85
action_162 (77) = happyShift action_86
action_162 (79) = happyShift action_87
action_162 (84) = happyShift action_88
action_162 (85) = happyShift action_89
action_162 (86) = happyShift action_90
action_162 (30) = happyGoto action_237
action_162 _ = happyFail (happyExpListPerState 162)

action_163 (64) = happyShift action_236
action_163 (73) = happyShift action_129
action_163 _ = happyReduce_40

action_164 _ = happyReduce_36

action_165 (64) = happyShift action_235
action_165 _ = happyReduce_71

action_166 (64) = happyShift action_234
action_166 (73) = happyShift action_129
action_166 _ = happyReduce_86

action_167 (32) = happyShift action_54
action_167 (54) = happyShift action_55
action_167 (14) = happyGoto action_232
action_167 (16) = happyGoto action_233
action_167 _ = happyFail (happyExpListPerState 167)

action_168 _ = happyReduce_49

action_169 (57) = happyShift action_231
action_169 (73) = happyShift action_129
action_169 _ = happyFail (happyExpListPerState 169)

action_170 _ = happyReduce_83

action_171 _ = happyReduce_79

action_172 _ = happyReduce_78

action_173 (32) = happyShift action_60
action_173 (54) = happyShift action_61
action_173 (60) = happyShift action_62
action_173 (66) = happyShift action_63
action_173 (67) = happyShift action_64
action_173 (68) = happyShift action_65
action_173 (69) = happyShift action_66
action_173 (70) = happyShift action_67
action_173 (71) = happyShift action_68
action_173 (78) = happyShift action_69
action_173 (17) = happyGoto action_56
action_173 (23) = happyGoto action_230
action_173 _ = happyFail (happyExpListPerState 173)

action_174 _ = happyReduce_57

action_175 (32) = happyShift action_60
action_175 (54) = happyShift action_61
action_175 (60) = happyShift action_62
action_175 (66) = happyShift action_63
action_175 (67) = happyShift action_64
action_175 (68) = happyShift action_65
action_175 (69) = happyShift action_66
action_175 (70) = happyShift action_67
action_175 (71) = happyShift action_68
action_175 (78) = happyShift action_69
action_175 (17) = happyGoto action_56
action_175 (23) = happyGoto action_229
action_175 _ = happyFail (happyExpListPerState 175)

action_176 (73) = happyShift action_129
action_176 _ = happyReduce_76

action_177 (50) = happyShift action_121
action_177 (51) = happyShift action_122
action_177 (52) = happyShift action_123
action_177 (53) = happyShift action_124
action_177 (56) = happyShift action_125
action_177 (60) = happyFail []
action_177 (61) = happyFail []
action_177 (63) = happyFail []
action_177 _ = happyReduce_108

action_178 (50) = happyShift action_121
action_178 (51) = happyShift action_122
action_178 (52) = happyShift action_123
action_178 (53) = happyShift action_124
action_178 (56) = happyShift action_125
action_178 (60) = happyFail []
action_178 (61) = happyFail []
action_178 (63) = happyFail []
action_178 _ = happyReduce_109

action_179 (50) = happyShift action_121
action_179 (51) = happyShift action_122
action_179 (52) = happyShift action_123
action_179 (53) = happyShift action_124
action_179 (56) = happyShift action_125
action_179 (60) = happyFail []
action_179 (61) = happyFail []
action_179 (63) = happyFail []
action_179 _ = happyReduce_110

action_180 (47) = happyShift action_119
action_180 (48) = happyShift action_120
action_180 (50) = happyShift action_121
action_180 (51) = happyShift action_122
action_180 (52) = happyShift action_123
action_180 (53) = happyShift action_124
action_180 (56) = happyShift action_125
action_180 (57) = happyShift action_225
action_180 (60) = happyShift action_126
action_180 (61) = happyShift action_127
action_180 (63) = happyShift action_128
action_180 (64) = happyShift action_226
action_180 (72) = happyShift action_227
action_180 (80) = happyShift action_228
action_180 _ = happyFail (happyExpListPerState 180)

action_181 (56) = happyShift action_125
action_181 _ = happyReduce_114

action_182 (56) = happyShift action_125
action_182 _ = happyReduce_113

action_183 (52) = happyShift action_123
action_183 (53) = happyShift action_124
action_183 (56) = happyShift action_125
action_183 _ = happyReduce_112

action_184 (52) = happyShift action_123
action_184 (53) = happyShift action_124
action_184 (56) = happyShift action_125
action_184 _ = happyReduce_111

action_185 (50) = happyShift action_121
action_185 (51) = happyShift action_122
action_185 (52) = happyShift action_123
action_185 (53) = happyShift action_124
action_185 (56) = happyShift action_125
action_185 (60) = happyShift action_126
action_185 (61) = happyShift action_127
action_185 (63) = happyShift action_128
action_185 _ = happyReduce_101

action_186 (50) = happyShift action_121
action_186 (51) = happyShift action_122
action_186 (52) = happyShift action_123
action_186 (53) = happyShift action_124
action_186 (56) = happyShift action_125
action_186 (60) = happyShift action_126
action_186 (61) = happyShift action_127
action_186 (63) = happyShift action_128
action_186 _ = happyReduce_102

action_187 (55) = happyShift action_224
action_187 _ = happyFail (happyExpListPerState 187)

action_188 (47) = happyShift action_119
action_188 (48) = happyShift action_120
action_188 (50) = happyShift action_121
action_188 (51) = happyShift action_122
action_188 (52) = happyShift action_123
action_188 (53) = happyShift action_124
action_188 (55) = happyShift action_223
action_188 (56) = happyShift action_125
action_188 (60) = happyShift action_126
action_188 (61) = happyShift action_127
action_188 (63) = happyShift action_128
action_188 (64) = happyShift action_199
action_188 _ = happyFail (happyExpListPerState 188)

action_189 (31) = happyShift action_72
action_189 (32) = happyShift action_73
action_189 (33) = happyShift action_74
action_189 (34) = happyShift action_75
action_189 (35) = happyShift action_76
action_189 (37) = happyShift action_77
action_189 (38) = happyShift action_78
action_189 (44) = happyShift action_79
action_189 (49) = happyShift action_80
action_189 (51) = happyShift action_81
action_189 (54) = happyShift action_82
action_189 (56) = happyShift action_83
action_189 (75) = happyShift action_84
action_189 (76) = happyShift action_85
action_189 (77) = happyShift action_86
action_189 (79) = happyShift action_87
action_189 (84) = happyShift action_88
action_189 (85) = happyShift action_89
action_189 (86) = happyShift action_90
action_189 (30) = happyGoto action_222
action_189 _ = happyFail (happyExpListPerState 189)

action_190 (31) = happyShift action_72
action_190 (32) = happyShift action_73
action_190 (33) = happyShift action_74
action_190 (34) = happyShift action_75
action_190 (35) = happyShift action_76
action_190 (37) = happyShift action_77
action_190 (38) = happyShift action_78
action_190 (44) = happyShift action_79
action_190 (49) = happyShift action_80
action_190 (51) = happyShift action_81
action_190 (54) = happyShift action_82
action_190 (56) = happyShift action_83
action_190 (75) = happyShift action_84
action_190 (76) = happyShift action_85
action_190 (77) = happyShift action_86
action_190 (79) = happyShift action_87
action_190 (84) = happyShift action_88
action_190 (85) = happyShift action_89
action_190 (86) = happyShift action_90
action_190 (30) = happyGoto action_221
action_190 _ = happyFail (happyExpListPerState 190)

action_191 (45) = happyShift action_220
action_191 (47) = happyShift action_119
action_191 (48) = happyShift action_120
action_191 (50) = happyShift action_121
action_191 (51) = happyShift action_122
action_191 (52) = happyShift action_123
action_191 (53) = happyShift action_124
action_191 (56) = happyShift action_125
action_191 (60) = happyShift action_126
action_191 (61) = happyShift action_127
action_191 (63) = happyShift action_128
action_191 _ = happyFail (happyExpListPerState 191)

action_192 (65) = happyShift action_219
action_192 _ = happyFail (happyExpListPerState 192)

action_193 (55) = happyShift action_218
action_193 _ = happyFail (happyExpListPerState 193)

action_194 (55) = happyShift action_217
action_194 _ = happyFail (happyExpListPerState 194)

action_195 (55) = happyShift action_216
action_195 _ = happyFail (happyExpListPerState 195)

action_196 (55) = happyShift action_215
action_196 _ = happyReduce_95

action_197 (55) = happyShift action_214
action_197 _ = happyFail (happyExpListPerState 197)

action_198 _ = happyReduce_123

action_199 (31) = happyShift action_72
action_199 (32) = happyShift action_73
action_199 (33) = happyShift action_74
action_199 (34) = happyShift action_75
action_199 (35) = happyShift action_76
action_199 (37) = happyShift action_77
action_199 (38) = happyShift action_78
action_199 (44) = happyShift action_79
action_199 (49) = happyShift action_80
action_199 (51) = happyShift action_81
action_199 (54) = happyShift action_82
action_199 (56) = happyShift action_83
action_199 (75) = happyShift action_84
action_199 (76) = happyShift action_85
action_199 (77) = happyShift action_86
action_199 (79) = happyShift action_87
action_199 (84) = happyShift action_88
action_199 (85) = happyShift action_89
action_199 (86) = happyShift action_90
action_199 (28) = happyGoto action_212
action_199 (30) = happyGoto action_213
action_199 _ = happyFail (happyExpListPerState 199)

action_200 (31) = happyShift action_72
action_200 (32) = happyShift action_73
action_200 (33) = happyShift action_74
action_200 (34) = happyShift action_75
action_200 (35) = happyShift action_76
action_200 (37) = happyShift action_77
action_200 (38) = happyShift action_78
action_200 (44) = happyShift action_79
action_200 (49) = happyShift action_80
action_200 (51) = happyShift action_81
action_200 (54) = happyShift action_82
action_200 (56) = happyShift action_83
action_200 (75) = happyShift action_84
action_200 (76) = happyShift action_85
action_200 (77) = happyShift action_86
action_200 (79) = happyShift action_87
action_200 (84) = happyShift action_88
action_200 (85) = happyShift action_89
action_200 (86) = happyShift action_90
action_200 (30) = happyGoto action_211
action_200 _ = happyFail (happyExpListPerState 200)

action_201 _ = happyReduce_124

action_202 (55) = happyShift action_210
action_202 _ = happyFail (happyExpListPerState 202)

action_203 (47) = happyShift action_119
action_203 (48) = happyShift action_120
action_203 (50) = happyShift action_121
action_203 (51) = happyShift action_122
action_203 (52) = happyShift action_123
action_203 (53) = happyShift action_124
action_203 (56) = happyShift action_125
action_203 (60) = happyShift action_126
action_203 (61) = happyShift action_127
action_203 (63) = happyShift action_128
action_203 (64) = happyShift action_199
action_203 _ = happyFail (happyExpListPerState 203)

action_204 (55) = happyShift action_209
action_204 _ = happyFail (happyExpListPerState 204)

action_205 (47) = happyShift action_119
action_205 (48) = happyShift action_120
action_205 (50) = happyShift action_121
action_205 (51) = happyShift action_122
action_205 (52) = happyShift action_123
action_205 (53) = happyShift action_124
action_205 (55) = happyShift action_208
action_205 (56) = happyShift action_125
action_205 (60) = happyShift action_126
action_205 (61) = happyShift action_127
action_205 (63) = happyShift action_128
action_205 _ = happyFail (happyExpListPerState 205)

action_206 (47) = happyShift action_119
action_206 (48) = happyShift action_120
action_206 (50) = happyShift action_121
action_206 (51) = happyShift action_122
action_206 (52) = happyShift action_123
action_206 (53) = happyShift action_124
action_206 (55) = happyShift action_207
action_206 (56) = happyShift action_125
action_206 (60) = happyShift action_126
action_206 (61) = happyShift action_127
action_206 (63) = happyShift action_128
action_206 _ = happyFail (happyExpListPerState 206)

action_207 _ = happyReduce_115

action_208 _ = happyReduce_120

action_209 _ = happyReduce_122

action_210 _ = happyReduce_121

action_211 (47) = happyShift action_119
action_211 (48) = happyShift action_120
action_211 (50) = happyShift action_121
action_211 (51) = happyShift action_122
action_211 (52) = happyShift action_123
action_211 (53) = happyShift action_124
action_211 (55) = happyShift action_260
action_211 (56) = happyShift action_125
action_211 (60) = happyShift action_126
action_211 (61) = happyShift action_127
action_211 (63) = happyShift action_128
action_211 _ = happyFail (happyExpListPerState 211)

action_212 _ = happyReduce_91

action_213 (47) = happyShift action_119
action_213 (48) = happyShift action_120
action_213 (50) = happyShift action_121
action_213 (51) = happyShift action_122
action_213 (52) = happyShift action_123
action_213 (53) = happyShift action_124
action_213 (56) = happyShift action_125
action_213 (60) = happyShift action_126
action_213 (61) = happyShift action_127
action_213 (63) = happyShift action_128
action_213 (64) = happyShift action_199
action_213 _ = happyReduce_90

action_214 (31) = happyShift action_72
action_214 (32) = happyShift action_73
action_214 (33) = happyShift action_74
action_214 (34) = happyShift action_75
action_214 (35) = happyShift action_76
action_214 (37) = happyShift action_77
action_214 (38) = happyShift action_78
action_214 (44) = happyShift action_79
action_214 (49) = happyShift action_80
action_214 (51) = happyShift action_81
action_214 (54) = happyShift action_82
action_214 (56) = happyShift action_83
action_214 (75) = happyShift action_84
action_214 (76) = happyShift action_85
action_214 (77) = happyShift action_86
action_214 (79) = happyShift action_87
action_214 (84) = happyShift action_88
action_214 (85) = happyShift action_89
action_214 (86) = happyShift action_90
action_214 (30) = happyGoto action_259
action_214 _ = happyFail (happyExpListPerState 214)

action_215 (31) = happyShift action_72
action_215 (32) = happyShift action_73
action_215 (33) = happyShift action_74
action_215 (34) = happyShift action_75
action_215 (35) = happyShift action_76
action_215 (37) = happyShift action_77
action_215 (38) = happyShift action_78
action_215 (44) = happyShift action_79
action_215 (49) = happyShift action_80
action_215 (51) = happyShift action_81
action_215 (54) = happyShift action_82
action_215 (56) = happyShift action_83
action_215 (75) = happyShift action_84
action_215 (76) = happyShift action_85
action_215 (77) = happyShift action_86
action_215 (79) = happyShift action_87
action_215 (84) = happyShift action_88
action_215 (85) = happyShift action_89
action_215 (86) = happyShift action_90
action_215 (30) = happyGoto action_258
action_215 _ = happyFail (happyExpListPerState 215)

action_216 (31) = happyShift action_72
action_216 (32) = happyShift action_73
action_216 (33) = happyShift action_74
action_216 (34) = happyShift action_75
action_216 (35) = happyShift action_76
action_216 (37) = happyShift action_77
action_216 (38) = happyShift action_78
action_216 (44) = happyShift action_79
action_216 (49) = happyShift action_80
action_216 (51) = happyShift action_81
action_216 (54) = happyShift action_82
action_216 (56) = happyShift action_83
action_216 (75) = happyShift action_84
action_216 (76) = happyShift action_85
action_216 (77) = happyShift action_86
action_216 (79) = happyShift action_87
action_216 (84) = happyShift action_88
action_216 (85) = happyShift action_89
action_216 (86) = happyShift action_90
action_216 (30) = happyGoto action_257
action_216 _ = happyFail (happyExpListPerState 216)

action_217 (31) = happyShift action_72
action_217 (32) = happyShift action_73
action_217 (33) = happyShift action_74
action_217 (34) = happyShift action_75
action_217 (35) = happyShift action_76
action_217 (37) = happyShift action_77
action_217 (38) = happyShift action_78
action_217 (44) = happyShift action_79
action_217 (49) = happyShift action_80
action_217 (51) = happyShift action_81
action_217 (54) = happyShift action_82
action_217 (56) = happyShift action_83
action_217 (75) = happyShift action_84
action_217 (76) = happyShift action_85
action_217 (77) = happyShift action_86
action_217 (79) = happyShift action_87
action_217 (84) = happyShift action_88
action_217 (85) = happyShift action_89
action_217 (86) = happyShift action_90
action_217 (30) = happyGoto action_256
action_217 _ = happyFail (happyExpListPerState 217)

action_218 (31) = happyShift action_72
action_218 (32) = happyShift action_73
action_218 (33) = happyShift action_74
action_218 (34) = happyShift action_75
action_218 (35) = happyShift action_76
action_218 (37) = happyShift action_77
action_218 (38) = happyShift action_78
action_218 (44) = happyShift action_79
action_218 (49) = happyShift action_80
action_218 (51) = happyShift action_81
action_218 (54) = happyShift action_82
action_218 (56) = happyShift action_83
action_218 (75) = happyShift action_84
action_218 (76) = happyShift action_85
action_218 (77) = happyShift action_86
action_218 (79) = happyShift action_87
action_218 (84) = happyShift action_88
action_218 (85) = happyShift action_89
action_218 (86) = happyShift action_90
action_218 (30) = happyGoto action_255
action_218 _ = happyFail (happyExpListPerState 218)

action_219 (31) = happyShift action_72
action_219 (32) = happyShift action_73
action_219 (33) = happyShift action_74
action_219 (34) = happyShift action_75
action_219 (35) = happyShift action_76
action_219 (37) = happyShift action_77
action_219 (38) = happyShift action_78
action_219 (44) = happyShift action_79
action_219 (49) = happyShift action_80
action_219 (51) = happyShift action_81
action_219 (54) = happyShift action_82
action_219 (56) = happyShift action_83
action_219 (75) = happyShift action_84
action_219 (76) = happyShift action_85
action_219 (77) = happyShift action_86
action_219 (79) = happyShift action_87
action_219 (84) = happyShift action_88
action_219 (85) = happyShift action_89
action_219 (86) = happyShift action_90
action_219 (30) = happyGoto action_254
action_219 _ = happyFail (happyExpListPerState 219)

action_220 (54) = happyShift action_253
action_220 _ = happyFail (happyExpListPerState 220)

action_221 (40) = happyShift action_252
action_221 (47) = happyShift action_119
action_221 (48) = happyShift action_120
action_221 (50) = happyShift action_121
action_221 (51) = happyShift action_122
action_221 (52) = happyShift action_123
action_221 (53) = happyShift action_124
action_221 (56) = happyShift action_125
action_221 (60) = happyShift action_126
action_221 (61) = happyShift action_127
action_221 (63) = happyShift action_128
action_221 _ = happyFail (happyExpListPerState 221)

action_222 (36) = happyShift action_251
action_222 (47) = happyShift action_119
action_222 (48) = happyShift action_120
action_222 (50) = happyShift action_121
action_222 (51) = happyShift action_122
action_222 (52) = happyShift action_123
action_222 (53) = happyShift action_124
action_222 (56) = happyShift action_125
action_222 (60) = happyShift action_126
action_222 (61) = happyShift action_127
action_222 (63) = happyShift action_128
action_222 _ = happyFail (happyExpListPerState 222)

action_223 _ = happyReduce_130

action_224 _ = happyReduce_129

action_225 _ = happyReduce_116

action_226 (31) = happyShift action_72
action_226 (32) = happyShift action_73
action_226 (33) = happyShift action_74
action_226 (34) = happyShift action_75
action_226 (35) = happyShift action_76
action_226 (37) = happyShift action_77
action_226 (38) = happyShift action_78
action_226 (44) = happyShift action_79
action_226 (49) = happyShift action_80
action_226 (51) = happyShift action_81
action_226 (54) = happyShift action_82
action_226 (56) = happyShift action_83
action_226 (75) = happyShift action_84
action_226 (76) = happyShift action_85
action_226 (77) = happyShift action_86
action_226 (79) = happyShift action_87
action_226 (84) = happyShift action_88
action_226 (85) = happyShift action_89
action_226 (86) = happyShift action_90
action_226 (30) = happyGoto action_250
action_226 _ = happyFail (happyExpListPerState 226)

action_227 (31) = happyShift action_72
action_227 (32) = happyShift action_73
action_227 (33) = happyShift action_74
action_227 (34) = happyShift action_75
action_227 (35) = happyShift action_76
action_227 (37) = happyShift action_77
action_227 (38) = happyShift action_78
action_227 (44) = happyShift action_79
action_227 (49) = happyShift action_80
action_227 (51) = happyShift action_81
action_227 (54) = happyShift action_82
action_227 (56) = happyShift action_83
action_227 (75) = happyShift action_84
action_227 (76) = happyShift action_85
action_227 (77) = happyShift action_86
action_227 (79) = happyShift action_87
action_227 (84) = happyShift action_88
action_227 (85) = happyShift action_89
action_227 (86) = happyShift action_90
action_227 (30) = happyGoto action_249
action_227 _ = happyFail (happyExpListPerState 227)

action_228 (31) = happyShift action_72
action_228 (32) = happyShift action_73
action_228 (33) = happyShift action_74
action_228 (34) = happyShift action_75
action_228 (35) = happyShift action_76
action_228 (37) = happyShift action_77
action_228 (38) = happyShift action_78
action_228 (44) = happyShift action_79
action_228 (49) = happyShift action_80
action_228 (51) = happyShift action_81
action_228 (54) = happyShift action_82
action_228 (56) = happyShift action_83
action_228 (75) = happyShift action_84
action_228 (76) = happyShift action_85
action_228 (77) = happyShift action_86
action_228 (79) = happyShift action_87
action_228 (84) = happyShift action_88
action_228 (85) = happyShift action_89
action_228 (86) = happyShift action_90
action_228 (30) = happyGoto action_248
action_228 _ = happyFail (happyExpListPerState 228)

action_229 (65) = happyShift action_247
action_229 (73) = happyShift action_129
action_229 _ = happyFail (happyExpListPerState 229)

action_230 (55) = happyShift action_246
action_230 (73) = happyShift action_129
action_230 _ = happyReduce_76

action_231 _ = happyReduce_80

action_232 _ = happyReduce_45

action_233 (64) = happyShift action_167
action_233 _ = happyReduce_44

action_234 (32) = happyShift action_52
action_234 (26) = happyGoto action_245
action_234 _ = happyFail (happyExpListPerState 234)

action_235 (32) = happyShift action_49
action_235 (21) = happyGoto action_244
action_235 _ = happyFail (happyExpListPerState 235)

action_236 (31) = happyShift action_22
action_236 (33) = happyShift action_9
action_236 (34) = happyShift action_23
action_236 (37) = happyShift action_24
action_236 (47) = happyShift action_25
action_236 (48) = happyShift action_26
action_236 (49) = happyShift action_27
action_236 (50) = happyShift action_28
action_236 (51) = happyShift action_29
action_236 (52) = happyShift action_30
action_236 (53) = happyShift action_31
action_236 (56) = happyShift action_32
action_236 (60) = happyShift action_33
action_236 (61) = happyShift action_34
action_236 (63) = happyShift action_35
action_236 (72) = happyShift action_36
action_236 (75) = happyShift action_37
action_236 (76) = happyShift action_38
action_236 (77) = happyShift action_39
action_236 (79) = happyShift action_40
action_236 (81) = happyShift action_41
action_236 (82) = happyShift action_42
action_236 (83) = happyShift action_43
action_236 (84) = happyShift action_44
action_236 (85) = happyShift action_45
action_236 (86) = happyShift action_46
action_236 (11) = happyGoto action_19
action_236 (12) = happyGoto action_243
action_236 _ = happyFail (happyExpListPerState 236)

action_237 (47) = happyShift action_119
action_237 (48) = happyShift action_120
action_237 (50) = happyShift action_121
action_237 (51) = happyShift action_122
action_237 (52) = happyShift action_123
action_237 (53) = happyShift action_124
action_237 (56) = happyShift action_125
action_237 (60) = happyShift action_126
action_237 (61) = happyShift action_127
action_237 (63) = happyShift action_128
action_237 _ = happyReduce_66

action_238 _ = happyReduce_59

action_239 (55) = happyShift action_242
action_239 _ = happyFail (happyExpListPerState 239)

action_240 (31) = happyShift action_72
action_240 (32) = happyShift action_73
action_240 (33) = happyShift action_74
action_240 (34) = happyShift action_75
action_240 (35) = happyShift action_76
action_240 (37) = happyShift action_77
action_240 (38) = happyShift action_78
action_240 (44) = happyShift action_79
action_240 (49) = happyShift action_80
action_240 (51) = happyShift action_81
action_240 (54) = happyShift action_82
action_240 (56) = happyShift action_83
action_240 (75) = happyShift action_84
action_240 (76) = happyShift action_85
action_240 (77) = happyShift action_86
action_240 (79) = happyShift action_87
action_240 (84) = happyShift action_88
action_240 (85) = happyShift action_89
action_240 (86) = happyShift action_90
action_240 (30) = happyGoto action_241
action_240 _ = happyFail (happyExpListPerState 240)

action_241 (47) = happyShift action_119
action_241 (48) = happyShift action_120
action_241 (50) = happyShift action_121
action_241 (51) = happyShift action_122
action_241 (52) = happyShift action_123
action_241 (53) = happyShift action_124
action_241 (55) = happyShift action_269
action_241 (56) = happyShift action_125
action_241 (60) = happyShift action_126
action_241 (61) = happyShift action_127
action_241 (63) = happyShift action_128
action_241 _ = happyFail (happyExpListPerState 241)

action_242 _ = happyReduce_69

action_243 _ = happyReduce_41

action_244 _ = happyReduce_72

action_245 _ = happyReduce_87

action_246 _ = happyReduce_77

action_247 (32) = happyShift action_60
action_247 (54) = happyShift action_61
action_247 (60) = happyShift action_62
action_247 (66) = happyShift action_63
action_247 (67) = happyShift action_64
action_247 (68) = happyShift action_65
action_247 (69) = happyShift action_66
action_247 (70) = happyShift action_67
action_247 (71) = happyShift action_68
action_247 (78) = happyShift action_69
action_247 (17) = happyGoto action_56
action_247 (23) = happyGoto action_268
action_247 _ = happyFail (happyExpListPerState 247)

action_248 (47) = happyShift action_119
action_248 (48) = happyShift action_120
action_248 (50) = happyShift action_121
action_248 (51) = happyShift action_122
action_248 (52) = happyShift action_123
action_248 (53) = happyShift action_124
action_248 (56) = happyShift action_125
action_248 (57) = happyShift action_267
action_248 (60) = happyShift action_126
action_248 (61) = happyShift action_127
action_248 (63) = happyShift action_128
action_248 _ = happyFail (happyExpListPerState 248)

action_249 (47) = happyShift action_119
action_249 (48) = happyShift action_120
action_249 (50) = happyShift action_121
action_249 (51) = happyShift action_122
action_249 (52) = happyShift action_123
action_249 (53) = happyShift action_124
action_249 (56) = happyShift action_125
action_249 (57) = happyShift action_266
action_249 (60) = happyShift action_126
action_249 (61) = happyShift action_127
action_249 (63) = happyShift action_128
action_249 _ = happyFail (happyExpListPerState 249)

action_250 (47) = happyShift action_119
action_250 (48) = happyShift action_120
action_250 (50) = happyShift action_121
action_250 (51) = happyShift action_122
action_250 (52) = happyShift action_123
action_250 (53) = happyShift action_124
action_250 (56) = happyShift action_125
action_250 (57) = happyShift action_265
action_250 (60) = happyShift action_126
action_250 (61) = happyShift action_127
action_250 (63) = happyShift action_128
action_250 _ = happyFail (happyExpListPerState 250)

action_251 (31) = happyShift action_72
action_251 (32) = happyShift action_73
action_251 (33) = happyShift action_74
action_251 (34) = happyShift action_75
action_251 (35) = happyShift action_76
action_251 (37) = happyShift action_77
action_251 (38) = happyShift action_78
action_251 (44) = happyShift action_79
action_251 (49) = happyShift action_80
action_251 (51) = happyShift action_81
action_251 (54) = happyShift action_82
action_251 (56) = happyShift action_83
action_251 (75) = happyShift action_84
action_251 (76) = happyShift action_85
action_251 (77) = happyShift action_86
action_251 (79) = happyShift action_87
action_251 (84) = happyShift action_88
action_251 (85) = happyShift action_89
action_251 (86) = happyShift action_90
action_251 (30) = happyGoto action_264
action_251 _ = happyFail (happyExpListPerState 251)

action_252 (31) = happyShift action_72
action_252 (32) = happyShift action_73
action_252 (33) = happyShift action_74
action_252 (34) = happyShift action_75
action_252 (35) = happyShift action_76
action_252 (37) = happyShift action_77
action_252 (38) = happyShift action_78
action_252 (44) = happyShift action_79
action_252 (49) = happyShift action_80
action_252 (51) = happyShift action_81
action_252 (54) = happyShift action_82
action_252 (56) = happyShift action_83
action_252 (75) = happyShift action_84
action_252 (76) = happyShift action_85
action_252 (77) = happyShift action_86
action_252 (79) = happyShift action_87
action_252 (84) = happyShift action_88
action_252 (85) = happyShift action_89
action_252 (86) = happyShift action_90
action_252 (30) = happyGoto action_263
action_252 _ = happyFail (happyExpListPerState 252)

action_253 (31) = happyShift action_72
action_253 (32) = happyShift action_73
action_253 (33) = happyShift action_74
action_253 (34) = happyShift action_75
action_253 (35) = happyShift action_76
action_253 (37) = happyShift action_77
action_253 (38) = happyShift action_78
action_253 (44) = happyShift action_79
action_253 (49) = happyShift action_80
action_253 (51) = happyShift action_81
action_253 (54) = happyShift action_82
action_253 (56) = happyShift action_83
action_253 (75) = happyShift action_84
action_253 (76) = happyShift action_85
action_253 (77) = happyShift action_86
action_253 (79) = happyShift action_87
action_253 (84) = happyShift action_88
action_253 (85) = happyShift action_89
action_253 (86) = happyShift action_90
action_253 (30) = happyGoto action_262
action_253 _ = happyFail (happyExpListPerState 253)

action_254 (47) = happyShift action_119
action_254 (48) = happyShift action_120
action_254 (50) = happyShift action_121
action_254 (51) = happyShift action_122
action_254 (52) = happyShift action_123
action_254 (53) = happyShift action_124
action_254 (55) = happyShift action_261
action_254 (56) = happyShift action_125
action_254 (60) = happyShift action_126
action_254 (61) = happyShift action_127
action_254 (63) = happyShift action_128
action_254 _ = happyFail (happyExpListPerState 254)

action_255 (52) = happyShift action_123
action_255 (53) = happyShift action_124
action_255 (56) = happyShift action_125
action_255 _ = happyReduce_103

action_256 (52) = happyShift action_123
action_256 (53) = happyShift action_124
action_256 (56) = happyShift action_125
action_256 _ = happyReduce_107

action_257 (52) = happyShift action_123
action_257 (53) = happyShift action_124
action_257 (56) = happyShift action_125
action_257 _ = happyReduce_106

action_258 (52) = happyShift action_123
action_258 (53) = happyShift action_124
action_258 (56) = happyShift action_125
action_258 _ = happyReduce_105

action_259 (52) = happyShift action_123
action_259 (53) = happyShift action_124
action_259 (56) = happyShift action_125
action_259 _ = happyReduce_104

action_260 _ = happyReduce_134

action_261 _ = happyReduce_133

action_262 (47) = happyShift action_119
action_262 (48) = happyShift action_120
action_262 (50) = happyShift action_121
action_262 (51) = happyShift action_122
action_262 (52) = happyShift action_123
action_262 (53) = happyShift action_124
action_262 (56) = happyShift action_125
action_262 (60) = happyShift action_126
action_262 (61) = happyShift action_127
action_262 (63) = happyShift action_128
action_262 (64) = happyShift action_270
action_262 _ = happyFail (happyExpListPerState 262)

action_263 (47) = happyShift action_119
action_263 (48) = happyShift action_120
action_263 (50) = happyShift action_121
action_263 (51) = happyShift action_122
action_263 (52) = happyShift action_123
action_263 (53) = happyShift action_124
action_263 (56) = happyShift action_125
action_263 (60) = happyShift action_126
action_263 (61) = happyShift action_127
action_263 (63) = happyShift action_128
action_263 _ = happyReduce_132

action_264 (47) = happyShift action_119
action_264 (48) = happyShift action_120
action_264 (50) = happyShift action_121
action_264 (51) = happyShift action_122
action_264 (52) = happyShift action_123
action_264 (53) = happyShift action_124
action_264 (56) = happyShift action_125
action_264 (60) = happyShift action_126
action_264 (61) = happyShift action_127
action_264 (63) = happyShift action_128
action_264 _ = happyReduce_131

action_265 _ = happyReduce_117

action_266 _ = happyReduce_119

action_267 _ = happyReduce_118

action_268 (73) = happyShift action_129
action_268 _ = happyReduce_81

action_269 _ = happyReduce_67

action_270 (54) = happyShift action_271
action_270 _ = happyFail (happyExpListPerState 270)

action_271 (32) = happyShift action_272
action_271 _ = happyFail (happyExpListPerState 271)

action_272 (72) = happyShift action_273
action_272 _ = happyFail (happyExpListPerState 272)

action_273 (32) = happyShift action_274
action_273 _ = happyFail (happyExpListPerState 273)

action_274 (55) = happyShift action_275
action_274 _ = happyFail (happyExpListPerState 274)

action_275 (73) = happyShift action_276
action_275 _ = happyFail (happyExpListPerState 275)

action_276 (31) = happyShift action_72
action_276 (32) = happyShift action_73
action_276 (33) = happyShift action_74
action_276 (34) = happyShift action_75
action_276 (35) = happyShift action_76
action_276 (37) = happyShift action_77
action_276 (38) = happyShift action_78
action_276 (44) = happyShift action_79
action_276 (49) = happyShift action_80
action_276 (51) = happyShift action_81
action_276 (54) = happyShift action_82
action_276 (56) = happyShift action_83
action_276 (75) = happyShift action_84
action_276 (76) = happyShift action_85
action_276 (77) = happyShift action_86
action_276 (79) = happyShift action_87
action_276 (84) = happyShift action_88
action_276 (85) = happyShift action_89
action_276 (86) = happyShift action_90
action_276 (30) = happyGoto action_277
action_276 _ = happyFail (happyExpListPerState 276)

action_277 (47) = happyShift action_119
action_277 (48) = happyShift action_120
action_277 (50) = happyShift action_121
action_277 (51) = happyShift action_122
action_277 (52) = happyShift action_123
action_277 (53) = happyShift action_124
action_277 (55) = happyShift action_278
action_277 (56) = happyShift action_125
action_277 (60) = happyShift action_126
action_277 (61) = happyShift action_127
action_277 (63) = happyShift action_128
action_277 _ = happyFail (happyExpListPerState 277)

action_278 _ = happyReduce_136

happyReduce_8 = happySpecReduce_1  11 happyReduction_8
happyReduction_8 _
	 =  HappyAbsSyn11
		 (VbOp True
	)

happyReduce_9 = happySpecReduce_1  11 happyReduction_9
happyReduction_9 _
	 =  HappyAbsSyn11
		 (VbOp False
	)

happyReduce_10 = happySpecReduce_1  11 happyReduction_10
happyReduction_10 (HappyTerminal (TIv happy_var_1))
	 =  HappyAbsSyn11
		 (ViOp happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  11 happyReduction_11
happyReduction_11 _
	 =  HappyAbsSyn11
		 (NotOp
	)

happyReduce_12 = happySpecReduce_1  11 happyReduction_12
happyReduction_12 _
	 =  HappyAbsSyn11
		 (AndOp
	)

happyReduce_13 = happySpecReduce_1  11 happyReduction_13
happyReduction_13 _
	 =  HappyAbsSyn11
		 (OrOp
	)

happyReduce_14 = happySpecReduce_1  11 happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn11
		 (EqualOp
	)

happyReduce_15 = happySpecReduce_1  11 happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn11
		 (MiOp
	)

happyReduce_16 = happySpecReduce_1  11 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn11
		 (MeOp
	)

happyReduce_17 = happySpecReduce_1  11 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn11
		 (AddOp
	)

happyReduce_18 = happySpecReduce_1  11 happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn11
		 (SustrOp
	)

happyReduce_19 = happySpecReduce_1  11 happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn11
		 (MultOp
	)

happyReduce_20 = happySpecReduce_1  11 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn11
		 (DivOp
	)

happyReduce_21 = happySpecReduce_1  11 happyReduction_21
happyReduction_21 _
	 =  HappyAbsSyn11
		 (NewOp
	)

happyReduce_22 = happySpecReduce_1  11 happyReduction_22
happyReduction_22 _
	 =  HappyAbsSyn11
		 (IncOp
	)

happyReduce_23 = happySpecReduce_1  11 happyReduction_23
happyReduction_23 _
	 =  HappyAbsSyn11
		 (UpdOp
	)

happyReduce_24 = happySpecReduce_1  11 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn11
		 (EntryOp
	)

happyReduce_25 = happySpecReduce_1  11 happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn11
		 (DEntryOp
	)

happyReduce_26 = happySpecReduce_1  11 happyReduction_26
happyReduction_26 _
	 =  HappyAbsSyn11
		 (IdOp
	)

happyReduce_27 = happySpecReduce_1  11 happyReduction_27
happyReduction_27 _
	 =  HappyAbsSyn11
		 (P1Op
	)

happyReduce_28 = happySpecReduce_1  11 happyReduction_28
happyReduction_28 _
	 =  HappyAbsSyn11
		 (P2Op
	)

happyReduce_29 = happySpecReduce_2  11 happyReduction_29
happyReduction_29 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn11
		 (EqOp happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_2  11 happyReduction_30
happyReduction_30 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn11
		 (AdOp happy_var_2
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  11 happyReduction_31
happyReduction_31 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn11
		 (SuOp happy_var_2
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_2  11 happyReduction_32
happyReduction_32 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn11
		 (DiOp happy_var_2
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_2  11 happyReduction_33
happyReduction_33 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn11
		 (MuOp happy_var_2
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  11 happyReduction_34
happyReduction_34 _
	 =  HappyAbsSyn11
		 (ConOp
	)

happyReduce_35 = happySpecReduce_2  11 happyReduction_35
happyReduction_35 _
	_
	 =  HappyAbsSyn11
		 (NullOp
	)

happyReduce_36 = happySpecReduce_3  11 happyReduction_36
happyReduction_36 _
	_
	_
	 =  HappyAbsSyn11
		 (DConOp
	)

happyReduce_37 = happySpecReduce_1  11 happyReduction_37
happyReduction_37 _
	 =  HappyAbsSyn11
		 (IsNullOp
	)

happyReduce_38 = happySpecReduce_1  11 happyReduction_38
happyReduction_38 _
	 =  HappyAbsSyn11
		 (HeadOp
	)

happyReduce_39 = happySpecReduce_1  11 happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn11
		 (TailOp
	)

happyReduce_40 = happySpecReduce_3  12 happyReduction_40
happyReduction_40 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 ([(happy_var_1,happy_var_3)]
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happyReduce 5 12 happyReduction_41
happyReduction_41 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 ((happy_var_1,happy_var_3) : happy_var_5
	) `HappyStk` happyRest

happyReduce_42 = happySpecReduce_0  13 happyReduction_42
happyReduction_42  =  HappyAbsSyn12
		 ([]
	)

happyReduce_43 = happySpecReduce_1  13 happyReduction_43
happyReduction_43 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  14 happyReduction_44
happyReduction_44 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1,happy_var_3]
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  14 happyReduction_45
happyReduction_45 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 : happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  15 happyReduction_46
happyReduction_46  =  HappyAbsSyn14
		 ([]
	)

happyReduce_47 = happySpecReduce_1  15 happyReduction_47
happyReduction_47 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  16 happyReduction_48
happyReduction_48 (HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn16
		 (VP happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  16 happyReduction_49
happyReduction_49 _
	(HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (P happy_var_2
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  17 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn17
		 (Un
	)

happyReduce_51 = happySpecReduce_1  17 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn17
		 (U_
	)

happyReduce_52 = happySpecReduce_1  17 happyReduction_52
happyReduction_52 _
	 =  HappyAbsSyn17
		 (L_
	)

happyReduce_53 = happySpecReduce_1  17 happyReduction_53
happyReduction_53 _
	 =  HappyAbsSyn17
		 (Su
	)

happyReduce_54 = happySpecReduce_1  17 happyReduction_54
happyReduction_54 _
	 =  HappyAbsSyn17
		 (Hi
	)

happyReduce_55 = happySpecReduce_1  17 happyReduction_55
happyReduction_55 _
	 =  HappyAbsSyn17
		 (Lo
	)

happyReduce_56 = happySpecReduce_1  17 happyReduction_56
happyReduction_56 (HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn17
		 (Gl (Var happy_var_1)
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  17 happyReduction_57
happyReduction_57 _
	(HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn17
		 (Gl happy_var_2
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  18 happyReduction_58
happyReduction_58 (HappyTerminal (TIv happy_var_1))
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  18 happyReduction_59
happyReduction_59 (HappyAbsSyn18  happy_var_3)
	_
	(HappyTerminal (TIv happy_var_1))
	 =  HappyAbsSyn18
		 (happy_var_1 : happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_0  19 happyReduction_60
happyReduction_60  =  HappyAbsSyn18
		 ([]
	)

happyReduce_61 = happySpecReduce_1  19 happyReduction_61
happyReduction_61 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  20 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn20
		 (Vb True
	)

happyReduce_63 = happySpecReduce_1  20 happyReduction_63
happyReduction_63 _
	 =  HappyAbsSyn20
		 (Vb False
	)

happyReduce_64 = happySpecReduce_1  20 happyReduction_64
happyReduction_64 (HappyTerminal (TIv happy_var_1))
	 =  HappyAbsSyn20
		 (Vi happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  20 happyReduction_65
happyReduction_65 (HappyTerminal (TIv happy_var_2))
	_
	 =  HappyAbsSyn20
		 (Vi (-happy_var_2)
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happyReduce 4 20 happyReduction_66
happyReduction_66 ((HappyAbsSyn30  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Vf happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_67 = happyReduce 6 20 happyReduction_67
happyReduction_67 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Vf happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_68 = happySpecReduce_3  20 happyReduction_68
happyReduction_68 _
	(HappyAbsSyn18  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Va happy_var_2
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happyReduce 5 20 happyReduction_69
happyReduction_69 (_ `HappyStk`
	(HappyTerminal (TString happy_var_4)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Vl happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_70 = happySpecReduce_2  20 happyReduction_70
happyReduction_70 _
	_
	 =  HappyAbsSyn20
		 (VN
	)

happyReduce_71 = happySpecReduce_3  21 happyReduction_71
happyReduction_71 (HappyAbsSyn20  happy_var_3)
	_
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn21
		 ([(happy_var_1,happy_var_3)]
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happyReduce 5 21 happyReduction_72
happyReduction_72 ((HappyAbsSyn21  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 ((happy_var_1,happy_var_3) : happy_var_5
	) `HappyStk` happyRest

happyReduce_73 = happySpecReduce_0  22 happyReduction_73
happyReduction_73  =  HappyAbsSyn21
		 ([]
	)

happyReduce_74 = happySpecReduce_1  22 happyReduction_74
happyReduction_74 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_2  23 happyReduction_75
happyReduction_75 (HappyTerminal (TString happy_var_2))
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn23
		 (Q happy_var_1 happy_var_2
	)
happyReduction_75 _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_3  23 happyReduction_76
happyReduction_76 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (Fun happy_var_1 happy_var_3
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happyReduce 5 23 happyReduction_77
happyReduction_77 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (Fun happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_78 = happySpecReduce_3  23 happyReduction_78
happyReduction_78 _
	(HappyAbsSyn23  happy_var_2)
	_
	 =  HappyAbsSyn23
		 (happy_var_2
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  23 happyReduction_79
happyReduction_79 _
	(HappyAbsSyn24  happy_var_2)
	_
	 =  HappyAbsSyn23
		 (Prod happy_var_2
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happyReduce 4 23 happyReduction_80
happyReduction_80 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (List happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_81 = happyReduce 6 23 happyReduction_81
happyReduction_81 ((HappyAbsSyn23  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (FO happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_82 = happySpecReduce_1  24 happyReduction_82
happyReduction_82 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_82 _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_3  24 happyReduction_83
happyReduction_83 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1 : happy_var_3
	)
happyReduction_83 _ _ _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_0  25 happyReduction_84
happyReduction_84  =  HappyAbsSyn24
		 ([]
	)

happyReduce_85 = happySpecReduce_1  25 happyReduction_85
happyReduction_85 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_3  26 happyReduction_86
happyReduction_86 (HappyAbsSyn23  happy_var_3)
	_
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn26
		 ([(happy_var_1,happy_var_3)]
	)
happyReduction_86 _ _ _  = notHappyAtAll 

happyReduce_87 = happyReduce 5 26 happyReduction_87
happyReduction_87 ((HappyAbsSyn26  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 ((happy_var_1,happy_var_3) : happy_var_5
	) `HappyStk` happyRest

happyReduce_88 = happySpecReduce_0  27 happyReduction_88
happyReduction_88  =  HappyAbsSyn26
		 ([]
	)

happyReduce_89 = happySpecReduce_1  27 happyReduction_89
happyReduction_89 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1
	)
happyReduction_89 _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_3  28 happyReduction_90
happyReduction_90 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1,happy_var_3]
	)
happyReduction_90 _ _ _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_3  28 happyReduction_91
happyReduction_91 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 : happy_var_3
	)
happyReduction_91 _ _ _  = notHappyAtAll 

happyReduce_92 = happySpecReduce_0  29 happyReduction_92
happyReduction_92  =  HappyAbsSyn28
		 ([]
	)

happyReduce_93 = happySpecReduce_1  29 happyReduction_93
happyReduction_93 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_93 _  = notHappyAtAll 

happyReduce_94 = happySpecReduce_1  30 happyReduction_94
happyReduction_94 (HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn30
		 (Var happy_var_1
	)
happyReduction_94 _  = notHappyAtAll 

happyReduce_95 = happySpecReduce_1  30 happyReduction_95
happyReduction_95 (HappyTerminal (TIv happy_var_1))
	 =  HappyAbsSyn30
		 (O (ViOp happy_var_1,Q Un "int")  []
	)
happyReduction_95 _  = notHappyAtAll 

happyReduce_96 = happySpecReduce_1  30 happyReduction_96
happyReduction_96 _
	 =  HappyAbsSyn30
		 (O (VbOp True,Q Un "bool")  []
	)

happyReduce_97 = happySpecReduce_1  30 happyReduction_97
happyReduction_97 _
	 =  HappyAbsSyn30
		 (O (VbOp False,Q Un "bool") []
	)

happyReduce_98 = happySpecReduce_2  30 happyReduction_98
happyReduction_98 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (NotOp,Fun (Q Un "bool") (Q Un "bool")) [happy_var_2]
	)
happyReduction_98 _ _  = notHappyAtAll 

happyReduce_99 = happySpecReduce_2  30 happyReduction_99
happyReduction_99 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (IncOp,Fun (Q Un "int") (Q Un "int")) [happy_var_2]
	)
happyReduction_99 _ _  = notHappyAtAll 

happyReduce_100 = happySpecReduce_2  30 happyReduction_100
happyReduction_100 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (AddInvOp,Fun (Q Un "int") (Q Un "int")) [happy_var_2]
	)
happyReduction_100 _ _  = notHappyAtAll 

happyReduce_101 = happySpecReduce_3  30 happyReduction_101
happyReduction_101 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (AndOp,Fun (Prod [(Q Un "bool"),(Q Un "bool")]) (Q Un "bool")) [happy_var_1,happy_var_3]
	)
happyReduction_101 _ _ _  = notHappyAtAll 

happyReduce_102 = happySpecReduce_3  30 happyReduction_102
happyReduction_102 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (OrOp,Fun (Prod [(Q Un "bool"),(Q Un "bool")]) (Q Un "bool")) [happy_var_1,happy_var_3]
	)
happyReduction_102 _ _ _  = notHappyAtAll 

happyReduce_103 = happyReduce 5 30 happyReduction_103
happyReduction_103 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIv happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (EqOp happy_var_3,Fun (Q Un "int") (Q Un "bool")) [happy_var_5]
	) `HappyStk` happyRest

happyReduce_104 = happyReduce 5 30 happyReduction_104
happyReduction_104 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIv happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (AdOp happy_var_3,Fun (Q Un "int") (Q Un "int")) [happy_var_5]
	) `HappyStk` happyRest

happyReduce_105 = happyReduce 5 30 happyReduction_105
happyReduction_105 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIv happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (SuOp happy_var_3,Fun (Q Un "int") (Q Un "int")) [happy_var_5]
	) `HappyStk` happyRest

happyReduce_106 = happyReduce 5 30 happyReduction_106
happyReduction_106 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIv happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (MuOp happy_var_3,Fun (Q Un "int") (Q Un "int")) [happy_var_5]
	) `HappyStk` happyRest

happyReduce_107 = happyReduce 5 30 happyReduction_107
happyReduction_107 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIv happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (DiOp happy_var_3,Fun (Q Un "int") (Q Un "int")) [happy_var_5]
	) `HappyStk` happyRest

happyReduce_108 = happySpecReduce_3  30 happyReduction_108
happyReduction_108 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (EqualOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "bool")) [happy_var_1,happy_var_3]
	)
happyReduction_108 _ _ _  = notHappyAtAll 

happyReduce_109 = happySpecReduce_3  30 happyReduction_109
happyReduction_109 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (MiOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "bool")) [happy_var_1,happy_var_3]
	)
happyReduction_109 _ _ _  = notHappyAtAll 

happyReduce_110 = happySpecReduce_3  30 happyReduction_110
happyReduction_110 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (MeOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "bool")) [happy_var_1,happy_var_3]
	)
happyReduction_110 _ _ _  = notHappyAtAll 

happyReduce_111 = happySpecReduce_3  30 happyReduction_111
happyReduction_111 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (AddOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3]
	)
happyReduction_111 _ _ _  = notHappyAtAll 

happyReduce_112 = happySpecReduce_3  30 happyReduction_112
happyReduction_112 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (SustrOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3]
	)
happyReduction_112 _ _ _  = notHappyAtAll 

happyReduce_113 = happySpecReduce_3  30 happyReduction_113
happyReduction_113 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (MultOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3]
	)
happyReduction_113 _ _ _  = notHappyAtAll 

happyReduce_114 = happySpecReduce_3  30 happyReduction_114
happyReduction_114 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (O (DivOp,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3]
	)
happyReduction_114 _ _ _  = notHappyAtAll 

happyReduce_115 = happyReduce 4 30 happyReduction_115
happyReduction_115 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (NewOp,Fun (Q Un "int") (Q Un "array")) [happy_var_3]
	) `HappyStk` happyRest

happyReduce_116 = happyReduce 4 30 happyReduction_116
happyReduction_116 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (EntryOp,Fun (Prod [(Q Un "array"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3]
	) `HappyStk` happyRest

happyReduce_117 = happyReduce 6 30 happyReduction_117
happyReduction_117 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (DEntryOp,Fun (Prod [(Q Un "array"),(Q Un "int"),(Q Un "int")]) (Q Un "int")) [happy_var_1,happy_var_3,happy_var_5]
	) `HappyStk` happyRest

happyReduce_118 = happyReduce 6 30 happyReduction_118
happyReduction_118 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (UpdOp,Fun (Prod [(Q Un "array"),(Q Un "int"),(Q Un "int")]) (Q Un "array")) [happy_var_1,happy_var_3,happy_var_5]
	) `HappyStk` happyRest

happyReduce_119 = happyReduce 6 30 happyReduction_119
happyReduction_119 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (DConOp,Fun (Prod [(List Un (Q Un "int")),(Q Un "int"),(List Un (Q Un "int"))]) (List Un (Q Un "int"))) [happy_var_1,happy_var_3,happy_var_5]
	) `HappyStk` happyRest

happyReduce_120 = happyReduce 4 30 happyReduction_120
happyReduction_120 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (IdOp,Fun (Q Un "int") (Q Un "int")) [happy_var_3]
	) `HappyStk` happyRest

happyReduce_121 = happyReduce 4 30 happyReduction_121
happyReduction_121 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (P1Op,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) happy_var_3
	) `HappyStk` happyRest

happyReduce_122 = happyReduce 4 30 happyReduction_122
happyReduction_122 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (P2Op,Fun (Prod [(Q Un "int"),(Q Un "int")]) (Q Un "int")) happy_var_3
	) `HappyStk` happyRest

happyReduce_123 = happySpecReduce_3  30 happyReduction_123
happyReduction_123 _
	(HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (happy_var_2
	)
happyReduction_123 _ _ _  = notHappyAtAll 

happyReduce_124 = happySpecReduce_3  30 happyReduction_124
happyReduction_124 _
	(HappyAbsSyn28  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (Tup happy_var_2
	)
happyReduction_124 _ _ _  = notHappyAtAll 

happyReduce_125 = happySpecReduce_2  30 happyReduction_125
happyReduction_125 (HappyTerminal (TIv happy_var_2))
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn30
		 (App happy_var_1 (O (ViOp happy_var_2,Q Un "int")  [])
	)
happyReduction_125 _ _  = notHappyAtAll 

happyReduce_126 = happySpecReduce_2  30 happyReduction_126
happyReduction_126 (HappyTerminal (TString happy_var_2))
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn30
		 (App happy_var_1 (Var happy_var_2)
	)
happyReduction_126 _ _  = notHappyAtAll 

happyReduce_127 = happySpecReduce_2  30 happyReduction_127
happyReduction_127 _
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn30
		 (App happy_var_1 (O (VbOp True,Q Un "bool")  [] )
	)
happyReduction_127 _ _  = notHappyAtAll 

happyReduce_128 = happySpecReduce_2  30 happyReduction_128
happyReduction_128 _
	(HappyTerminal (TString happy_var_1))
	 =  HappyAbsSyn30
		 (App happy_var_1 (O (VbOp False,Q Un "bool")  [] )
	)
happyReduction_128 _ _  = notHappyAtAll 

happyReduce_129 = happyReduce 4 30 happyReduction_129
happyReduction_129 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (App happy_var_1 (Tup happy_var_3)
	) `HappyStk` happyRest

happyReduce_130 = happyReduce 4 30 happyReduction_130
happyReduction_130 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (App happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_131 = happyReduce 6 30 happyReduction_131
happyReduction_131 ((HappyAbsSyn30  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (Let happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_132 = happyReduce 6 30 happyReduction_132
happyReduction_132 ((HappyAbsSyn30  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (If happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_133 = happyReduce 6 30 happyReduction_133
happyReduction_133 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (Lam  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_134 = happyReduce 5 30 happyReduction_134
happyReduction_134 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (O (ConOp,Fun (Prod [(Q Un "int"),List Un (Q Un "int")]) (List Un (Q Un "int"))) [happy_var_2,happy_var_4]
	) `HappyStk` happyRest

happyReduce_135 = happySpecReduce_2  30 happyReduction_135
happyReduction_135 _
	_
	 =  HappyAbsSyn30
		 (O (NullOp,List Un (Q Un "int"))  []
	)

happyReduce_136 = happyReduce 15 30 happyReduction_136
happyReduction_136 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_14) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_11)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TString happy_var_9)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn30
		 (Case happy_var_2 happy_var_3 happy_var_6 (P [VP happy_var_9,VP happy_var_11]) happy_var_14
	) `HappyStk` happyRest

happyReduce_137 = happySpecReduce_2  30 happyReduction_137
happyReduction_137 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (HeadOp,Fun (List Un (Q Un "int")) (Q Un "int")) [happy_var_2]
	)
happyReduction_137 _ _  = notHappyAtAll 

happyReduce_138 = happySpecReduce_2  30 happyReduction_138
happyReduction_138 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (TailOp,Fun (List Un (Q Un "int")) (List Un (Q Un "int"))) [happy_var_2]
	)
happyReduction_138 _ _  = notHappyAtAll 

happyReduce_139 = happySpecReduce_2  30 happyReduction_139
happyReduction_139 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (O (IsNullOp,Fun (List Un (Q Un "int")) (Q Un "bool")) [happy_var_2]
	)
happyReduction_139 _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 87 87 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TIv happy_dollar_dollar -> cont 31;
	TString happy_dollar_dollar -> cont 32;
	TTrue -> cont 33;
	TFalse -> cont 34;
	TLet -> cont 35;
	TIn -> cont 36;
	TInc -> cont 37;
	TIf -> cont 38;
	TThen -> cont 39;
	TElse -> cont 40;
	TSplit -> cont 41;
	TAs -> cont 42;
	TNull -> cont 43;
	TCase -> cont 44;
	TOf -> cont 45;
	TEq -> cont 46;
	TOr -> cont 47;
	TAnd -> cont 48;
	TNot -> cont 49;
	TAdd -> cont 50;
	TMinus -> cont 51;
	TMult -> cont 52;
	TDiv -> cont 53;
	TOB -> cont 54;
	TCB -> cont 55;
	TOC -> cont 56;
	TCC -> cont 57;
	TOL -> cont 58;
	TCL -> cont 59;
	TMe -> cont 60;
	TMi -> cont 61;
	TMa -> cont 62;
	TEqual -> cont 63;
	TComma -> cont 64;
	TPunto -> cont 65;
	THi -> cont 66;
	TSu -> cont 67;
	TUn -> cont 68;
	TU_ -> cont 69;
	TL_ -> cont 70;
	TLo -> cont 71;
	T2p -> cont 72;
	Tfl -> cont 73;
	Tunit -> cont 74;
	Tp1 -> cont 75;
	Tp2 -> cont 76;
	Tid -> cont 77;
	TLambda -> cont 78;
	TNew -> cont 79;
	TAsig -> cont 80;
	TUpd -> cont 81;
	TEntry -> cont 82;
	TDEntry -> cont 83;
	TIsNull -> cont 84;
	THead -> cont 85;
	TTail -> cont 86;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 87 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => IO a -> (a -> IO b) -> IO b
happyThen = (>>=)
happyReturn :: () => a -> IO a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> IO a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> IO a
happyError' = (\(tokens, _) -> happyError tokens)
pexc tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn30 z -> happyReturn z; _other -> notHappyAtAll })

ptau tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_1 tks) (\x -> case x of {HappyAbsSyn23 z -> happyReturn z; _other -> notHappyAtAll })

ptaus tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_2 tks) (\x -> case x of {HappyAbsSyn24 z -> happyReturn z; _other -> notHappyAtAll })

ppat tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_3 tks) (\x -> case x of {HappyAbsSyn16 z -> happyReturn z; _other -> notHappyAtAll })

ppi tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_4 tks) (\x -> case x of {HappyAbsSyn26 z -> happyReturn z; _other -> notHappyAtAll })

pstr tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_5 tks) (\x -> case x of {HappyAbsSyn21 z -> happyReturn z; _other -> notHappyAtAll })

psigma tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_6 tks) (\x -> case x of {HappyAbsSyn12 z -> happyReturn z; _other -> notHappyAtAll })

pvalue tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_7 tks) (\x -> case x of {HappyAbsSyn20 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


data Token = TIv Int | TString String | TTrue | TFalse 
           | TAdd | TInc
           | TMinus 
           | TMult | TDiv
           | TOB | TCB | TOP | TCP 
           | TOr 
           | TAnd 
           | TNot 
           | TMe | TMa
           | TMi 
           | TEqual 
           | TLet | TIn | TEq 
           | TComma | TPunto
           | THi | TSu | TUn | TU_ | TLo | TL_
           | T2p | Tunit | Tfl 
           | Tid | Tp1 | Tp2 | TLambda 
           | TSplit | TAs 
           | TIf | TThen | TElse 
           | TNew | TAsig | TUpd | TEntry | TDEntry | TOC | TCC | TOL | TCL 
           | TCase | TOf | TNull | TIsNull | THead | TTail 
            deriving Show

happyError tokens = error "Parse error" 
symbols :: [Char]
symbols = ['|', '&',  '=', '+', 
           '-', '*','%', '(', ')' , '<', '>' , ':', '.',
           ' ', ',', '\\', '\n','\t','{','}','[',']']

lexer :: String -> [Token]
lexer [] = []
lexer ('\n':cs) = lexer cs
lexer ('\t':cs) = lexer cs
lexer ('|':cs) = if cs!!0 == '|' then TOr :lexer (tail cs) else error "Malformed sequence"
lexer ('&':cs) = if cs!!0 == '&' then TAnd :lexer (tail cs) else error "Malformed sequence"
lexer ('<':cs) = if cs!!0 == '=' then TMi : lexer (tail cs) else  if cs!!0 == '-' then TAsig : lexer (tail cs) else TMe : lexer cs 
lexer ('=':cs) = if cs!!0 == '=' then TEqual : lexer (tail cs) else TEq : lexer cs
lexer ('+':cs) = TAdd : lexer cs
lexer ('-':cs) = if cs!!0 == '>' then Tfl : lexer (tail cs) else TMinus : lexer cs
lexer ('*':cs) = TMult : lexer cs
lexer ('%':cs) = TDiv : lexer cs
lexer ('>':cs) = TMa : lexer cs
lexer ('<':cs) = TMe : lexer cs
lexer ('(':cs) = TOB : lexer cs
lexer (')':cs) = TCB : lexer cs
lexer ('[':cs) = TOC : lexer cs
lexer (']':cs) = TCC : lexer cs
lexer ('{':cs) = TOL : lexer cs
lexer ('}':cs) = TCL : lexer cs
lexer (',':cs) = TComma : lexer cs
lexer (':':cs) = T2p : lexer cs 

lexer ('\\':cs) = TLambda : lexer cs
lexer ('.':cs)  = TPunto : lexer cs


lexer w@(c:cs) 
      | isSpace c = lexer cs
      | isDigit c = lexNum w
      | isAlpha c = lexString w
      | otherwise = error ("lexer: Not recognized symbol: " ++ [c])


taulexer :: String -> [Token]
taulexer [] = []
taulexer ('\n':cs) = taulexer cs
taulexer ('\t':cs) = taulexer cs
taulexer ('-':cs) = if cs!!0 == '>' 
                  then Tfl :taulexer (tail cs) 
                  else error "Malformed sequence"
taulexer (':':cs) = T2p :taulexer cs
taulexer (',':cs) = TComma :taulexer cs  
taulexer ('(':cs) = TOB : taulexer cs
taulexer (')':cs) = TCB : taulexer cs
taulexer ('>':cs) = TMa : taulexer cs
taulexer ('<':cs) = TMe : taulexer cs
taulexer ('[':cs) = TOC : taulexer cs
taulexer (']':cs) = TCC : taulexer cs
taulexer ('{':cs) = TOL : taulexer cs
taulexer ('}':cs) = TCL : taulexer cs

taulexer w@(c:cs) 
      | isSpace c = taulexer cs
      | isAlpha c = lexString w
      | otherwise = error ("taulexer: Not recognized symbol: " ++ [c])


etalexer :: String -> [Token]
etalexer [] = []
etalexer ('\n':cs) = etalexer cs
etalexer ('\t':cs) = etalexer cs
etalexer ('=':cs) = if cs!!0 == '=' 
                  then TEq :etalexer (tail cs) 
                  else TEq : etalexer cs
etalexer ('(':cs) = TOB : etalexer cs
etalexer (')':cs) = TCB : etalexer cs
etalexer (',':cs) = TComma : etalexer cs
etalexer ('.':cs) = TPunto : etalexer cs
etalexer ('\\':cs) = TLambda : etalexer cs
etalexer ('[':cs) = TOC : etalexer cs
etalexer (']':cs) = TCC : etalexer cs
etalexer ('{':cs) = TOL : etalexer cs
etalexer ('}':cs) = TCL : etalexer cs

etalexer w@(c:cs) 
      | isSpace c = etalexer cs
      | isDigit c = lexNum w
      | isAlpha c = lexString w
      | otherwise = error ("etalexer: Not recognized symbol: " ++ [c])

lexString cs = case lookup w keywords of
                 Nothing -> TString w: lexer rest
                 (Just tok) -> tok : lexer rest
    where (w,rest) = span (\x -> not (elem x symbols)) cs

lexNum cs = TIv (read num) : lexer rest
      where (num,rest) = span isDigit cs

keywords :: [(String,Token)]
keywords = [("true",TTrue),
            ("false",TFalse),
            ("not",TNot),
            ("su",TSu),
            ("hi",THi),
            ("un",TUn),
            ("un!",TU_),
            ("lo",TLo),
            ("lo!",TL_),
            ("unit",Tunit),
            ("id",Tid),
            ("p1",Tp1),
            ("p2",Tp2),
            ("let", TLet),
            ("in", TIn),
            ("if", TIf),
            ("then", TThen),
            ("else", TElse),
            ("split", TSplit),
            ("as", TAs),
            ("new", TNew),
            ("upd", TUpd),
            ("ent", TEntry),
            ("den", TDEntry),
            ("inc", TInc),
            ("null", TNull),
            ("isNull", TIsNull),
            ("case", TCase),
            ("of", TOf),
            ("tail", TTail),
            ("head", THead)
           ]
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
