(* User  declarations *)
fun lookup "special" = 1000
  | lookup s = 0 

%%
(* required declarations *)
%name Calc

%term
  ID of string | NUM of int | CONST of bool
| PLUS | TIMES | SUB | DIV  | RPAREN | LPAREN | EOF | TERM
| EQUALS | LET | IN | END | LESSTHAN | GREATERTHAN | NEGATE | ASSIGN
| IF | THEN | ELSE | FI | IMPLIES | AND | OR | XOR | NOT | ARROW | DEF | FN | FUN | COLON | INT | BOOL

%nonterm EXP of AST.exp | START of AST.program | DECL of AST.decl | TYPE of AST.basictype | COMPOUNDTYPE of AST.compoundtype | PROGRAM of AST.program

%pos int

(*optional declarations *)
%eop EOF
%noshift EOF

(* %header  *)

%right ARROW
%right DEF
%right IF THEN ELSE FI
%right IMPLIES
%left AND OR XOR EQUALS
%right NOT
%left LESSTHAN GREATERTHAN
%left SUB PLUS
%left TIMES DIV
%right NEGATE

%start START

%verbose

%%

  START: PROGRAM (PROGRAM)

  PROGRAM: EXP TERM PROGRAM (AST.Node(EXP, PROGRAM))
  | EXP (AST.Leaf(EXP))

  DECL: ID ASSIGN EXP (AST.ValDecl(ID, EXP))
  | FUN ID LPAREN ID COLON COMPOUNDTYPE RPAREN COLON COMPOUNDTYPE DEF EXP (AST.FunDecl(ID1, ID2, COMPOUNDTYPE1, COMPOUNDTYPE2, EXP))

  TYPE: INT (AST.Int)
  | BOOL (AST.Bool)

  COMPOUNDTYPE: TYPE (AST.SingleType(TYPE))
  | COMPOUNDTYPE ARROW COMPOUNDTYPE (AST.CompoundType(COMPOUNDTYPE1, COMPOUNDTYPE2))
  | LPAREN COMPOUNDTYPE RPAREN (COMPOUNDTYPE)

  EXP: NUM (AST.NumExp(NUM))
  | ID (AST.VarExp(ID))
  | CONST (AST.BoolExp(CONST))
  | EXP PLUS EXP (AST.BinExp(AST.Add, EXP1,  EXP2))
  | EXP SUB EXP (AST.BinExp(AST.Sub, EXP1,  EXP2))
  | EXP TIMES EXP (AST.BinExp(AST.Mul, EXP1, EXP2))
  | EXP DIV EXP (AST.BinExp(AST.Div, EXP1, EXP2))
  | NEGATE EXP (AST.UnExp(AST.Negate, EXP))
  | EXP LESSTHAN EXP (AST.BinExp(AST.LessThan, EXP1, EXP2))
  | EXP GREATERTHAN EXP (AST.BinExp(AST.GreaterThan, EXP1, EXP2))
  | LET DECL IN EXP END (AST.LetExp(DECL, EXP))
  | EXP EQUALS EXP (AST.BinExp(AST.Equals, EXP1, EXP2))
  | IF EXP THEN EXP ELSE EXP FI (AST.IfExp(EXP1, EXP2, EXP3))
  | EXP IMPLIES EXP (AST.BinExp(AST.Implies, EXP1, EXP2))
  | EXP AND EXP (AST.BinExp(AST.And, EXP1, EXP2))
  | EXP OR EXP (AST.BinExp(AST.Or, EXP1, EXP2))
  | EXP XOR EXP (AST.BinExp(AST.Xor, EXP1, EXP2))
  | NOT EXP (AST.UnExp(AST.Not, EXP))
  | LPAREN EXP RPAREN (EXP)
  | FN LPAREN ID COLON COMPOUNDTYPE RPAREN COLON COMPOUNDTYPE DEF EXP (AST.FnExp(ID, COMPOUNDTYPE1, COMPOUNDTYPE2, EXP))
  | LPAREN EXP EXP RPAREN (AST.AppExp(EXP1, EXP2))
  | FUN ID LPAREN ID COLON COMPOUNDTYPE RPAREN COLON COMPOUNDTYPE DEF EXP (AST.FunExp(ID1, ID2, COMPOUNDTYPE1, COMPOUNDTYPE2, EXP))
  
