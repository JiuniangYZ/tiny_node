%lex
%%

\s+         /*skip*/
[A-Za-z][A-Za-z_0-9]*       return 'IDENTIFIER'
[0-9]+("."[0-9]+)?\b        return 'NUMBER';
//\"+[a-zA-Z_0-9]+\"          return 'STRING'
'='                         return '=';
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
','                         return ',';
"=="                        return 'EQUAL';
<<EOF>>                     return 'EOF';
.                           return 'INVALID';


/lex
%left '='
%left '+' '-'
%left '*' '/'
%left '>' '<'
%left EQUAL
%start all

%%

Program:
  : /*empty*/ {}
  | Program FuncDecl {} //no need here
  ;

FuncDecl:
  : FuncName '(' Args ')' '{' VarDecls Stmts '}' {} //this is a whole func
  ;

FuncName 
  : IDENTIFIER {$$ = $1;}
  ;

Args:
  : /*empty*/ {$$ =[];}
  | PArgs {} //we need a slice to transform tree to a vector
  ;

PArgs
  : Exp {}
  | PArgs ',' Exp {}
  ;

Stmts
  : /*empty*/ {}
  | Stmts Stmt {}
  ;

Stmt
  : AssignStmt {}
  | CallStmt {}
  | RetStmt {}
  | IfStmt {}
  | WhileStmt {}
  | BreakStmt {}
  | ContinueStmt {}
  ;
  
