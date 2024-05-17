/* 
    Omoniyi Tomjones
    CMSC 430: Computer Theory and Design
    Project 3
    Summer 2023

   
   Project 3 Parser with semantic actions for the interpreter */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>
#include <queue>
#include <cassert>

using namespace std;

#include "values.h"
#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

queue<int> argQueue;

%}

%define parse.error verbose

%union {
	Operators oper;
	Types type;
	double value;
	vector<double>* list;
	CharPtr iden;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL REAL BOOL_LITERAL HEX_LITERAL
%token <oper> ADDOP MULOP ANDOP RELOP EXPOP REMOP NEGOP OROP SUBOP NOTOP

%token ARROW RIGHT LEFT

%token <type> BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN IF THEN ELSIF ENDIF FOLD ENDFOLD LEFTFOLD RIGHTFOLD

%type <value> body statement_ statement cases case expression term primary
	 condition relation LEFT RIGHT

%type <list> list expressions

%%

function:	
	function_header optional_variable  body ';' {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';' ;

type:
	REAL |
	INTEGER {$$ = INT_TYPE;} |
	CHARACTER {$$ = CHAR_TYPE; };
	
optional_variable:
	variable |
	%empty ;


variable:	
	IDENTIFIER ':' type IS statement_ {scalars.insert($1, $3);}; |
	IDENTIFIER ':' primary RETURNS statement_ {scalars.insert($1, $3);}; |
	IDENTIFIER ':' primary {scalars.insert($1, $3);} |
	IDENTIFIER ':' primary RETURNS primary {scalars.insert($1, $3);} |

	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $5);} ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} | 
	expression {$$ = new vector<double>(); $$->push_back($1);}

body:
	BEGIN_ statement_ END {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression {$$ = $2 ? $4 : $6;} |

	IF condition THEN statement_ ELSIF condition THEN statement_ ELSIF condition THEN statement_
	ELSE statement_ ENDIF {$$ = $2 ? $4 : $$ = $6 ? $8 : $$ = $10 ? $12 : $14;} |

	IF condition THEN statement_ ELSE statement_ ENDIF {$$ = $2 ? $4 : $$ = $4 ? $6: $6;} |

	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH
		{$$ = !isnan($4) ? $4 : $7;} ;

cases:
	cases case {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;} ; 

condition:
	NOTOP condition { $$ = !$2; } |
	condition ANDOP relation {$$ = $1 && $2;} |
	condition OROP relation {$$ = $1 || $2;} |
	expression |
	primary |
	relation ;

relation:
	expression |
	
	'(' condition ')' {$$ = $2;};

expression:
	FOLD LEFT ADDOP expression ENDFOLD {$$ = evaluateFold($2, $4, true);} | 
	FOLD RIGHT ADDOP expression ENDFOLD {$$ = evaluateFold($2, $4, false);} |
	primary ADDOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	primary RELOP primary {$$ = evaluateRelational($1, $2, $3);}  |
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |	
	expression NEGOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	
	expression REMOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	expression OROP expression {$$ = evaluateRelational($1, $2, $3);} |
	expression MULOP primary {$$ = evaluateArithmetic($1, $2, $3);} |
	primary EXPOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	primary ADDOP expression {$$ = evaluateArithmetic($1, $2, $3);}  |
	primary ANDOP expression {$$ = evaluateArithmetic($1, $2, $3);}  |
	term ;
  
term:
	primary MULOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	term MULOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	term REMOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	expression ADDOP expression {$$ = evaluateArithmetic($1, $2, $3);}  |
	expression REMOP expression {$$ = evaluateArithmetic($1, $2, $3);} |
	term EXPOP expression {$$ = evaluateArithmetic($1, $2, $3);}  |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL |
	CHAR_LITERAL |
	HEX_LITERAL |
	IDENTIFIER |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);} |
	NEGOP INT_LITERAL {$$ = -$2;} ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
