%lex
%%

\s+         /*skip*/
[A-Za-z][A-Za-z_0-9]*       return 'IDENTIFIER'
[0-9]+("."[0-9]+)?\b        return 'NUMBER';
"return"                    return 'RETURN'; 
"while"                     return 'WHILE';
"if"                        return 'IF';   
"else"                      return 'ELSE';
"break"                     return 'BREAK';
"continue"                  return 'CONTINUE';  
"let"                       return 'LET';               
"="                         return '=';
"+"                         return '+'; 
"{"                         return '{';
"}"                         return '}';
"-"                         return '-'; 
">"                         return '>'; 
"<"                         return '<'; 
"*"                         return '*'; 
"/"                         return '/'; 
"?"                         return '?'; 
":"                         return ':';
"("                         return '(';
")"                         return ')';
","                         return ',';
"!"                         return 'NOT';
"=="                        return 'EQUAL';
<<EOF>>                     return 'EOF';
.                           return 'INVALID';


/lex
%left '='
%left '+' '-'
%left '*' '/'
%left '>' '<'
%left EQUAL
%right 
%start Program

%%

Program:
  : /*empty*/ {}
  | Program FuncDecl {} //no need here
  ;

FuncDecl:
  : FuncName '(' ArgDecls ')' '{' VarDecls Stmts '}' {yy.funcBuilder($1,$3,$4,$5)} //this is a whole func
  ;

VarDecls
  : /*empty*/ {}
  | PvarDecls { $$ = yy.argSlicer($1);}
  ;

PvarDecls
  : LET IDENTIFIER { $$ = {type:"p_var_decls", left:null, right: $2}; }
  | PvarDecls ',' IDENTIFIER { $$ = {type:"p_var_decls", left:$1, right: $2}; }
  ;

FuncName 
  : IDENTIFIER {$$ = $1;}
  ;

ArgDecls
  : /*empty*/ {$$ = [] ;} //basically arg decls is a serious of identifiers
  | PargDecls {$$ = yy.argDeclSlicer($1)}
  ;

PargDecls
  : Eidentifier {$$ = {type:"p_arg_decls", left:null, right:$1};}
  | PargDecls ',' Eidentifier {$$ = {type:"p_arg_decls", left:$1, right:$3};}
  ;

Args:
  : /*empty*/ {$$ = [] ;}
  | Pargs { $$ = yy.argSlicer($1) } //we need a slicer to transform tree to a vector
  ;

Pargs
  : Exp { $$ = {type:"p_args", left:null, right:$1} }//now left is null and right is a exp
  | Pargs ',' Exp { $$ = {type:"p_args", left: $1, right: $3}; }
  ;

Stmts
  : /*empty*/ {}
  | Stmt Stmts {}
  ;

Stmt
  : AssignStmt { $$ = $1; }
  | CallStmt {$$ = $1;}
  | RetStmt {$$ = $1;}
  | IfStmt {$$ = $1;}
  | WhileStmt {$$ = $1;}
  | BreakStmt {$$ = $1;}
  | ContinueStmt {$$ =$1;}
  ;

AssignStmt
  : IDENTIFIER '=' Exp ';' { $$ = yy.assBuilder($1, $3); } //$3 is a "exp" node $1 is a identifier node
  ;

CallStmt 
  : FuncCall ';' {}
  ;

RetStmt
  : RETURN Exp {$$ = {type:"ret", value:$2};}
  | RETURN {$$ = {type:"ret", value:null};} 
  ;

WhileStmt 
  : WHILE TestExpr  StmtBlock {$$ = {type:"while"}} 
  ;

IfStmt
  : IF TestExpr StmtBlock {}
  | IF TestExpr StmtBlock ELSE StmtBlock {}
  ;

TestExpr
  : '(' Expr ')' { $$ = $2 }
  ;

StmtBlock
  : '{' Stmts '}' { $$ = yy.stmtSlicer($2); }//transfer a stmt tree to a vector
  ; 

FuncCall
  : IDENTIFIER '(' Args ')' {$$ = {type:"exp", subType:"func_call", func:String($1), args:$3};}//here args is a serious of exps
  ;

Exp
  : Exp '+' Exp   {$$ = {type:"exp", subType:"add", left:$1, right:$3 };}
  | Exp '-' Exp   {$$ = {type:"exp", subType:"sub", left:$1, right:$3 };}
  | Exp '*' Exp   {$$ = {type:"exp", subType:"mul", left:$1, right:$3 };}
  | Exp '/' Exp   {$$ = {type:"exp", subType:"div", left:$1, right:$3 };}
  | Exp EQUAL Exp {$$ = {type:"exp", subType:"equal", left:$1, right:$3 };}
  | Exp '>' Exp   {$$ = {type:"exp", subType:"bigger_than", left:$1, right:$3 };}
  | Exp '<' Exp   {$$ = {type:"exp", subType:"smaller_than", left:$1, right:$3 };}
  | '!' Exp       {$$ = {type:"exp", subType:"not", value:$2};}
  | FuncCall      {$$ = $1;}
  | '(' Exp ')'   {$$ = $1;}
  | Eidentifier    {$$ = $1;} 
  | NumConstant   {$$ = $1;}
  ;

NumberConstant
  : NUMBER {$$ = {type:"number_constant",value:Number($1)};}
  ;

Eidentifier
  : IDENTIFIER {$$ = {type:"exp", subType:"identifier", value:String($1)}} //a ref to a var in current namespace(for now its just a var)
  ;












