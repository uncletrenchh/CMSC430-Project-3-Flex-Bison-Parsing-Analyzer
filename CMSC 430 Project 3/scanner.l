/* 
    Omoniyi Tomjones
    CMSC 430: Computer Theory and Design
    Project 3
    Summer 2023
    */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <cstdlib>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"
#include "types.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		"\/\/".*\n|"\-\-".*\n
line		[\n]
form        [\f]
hex     (\#[a-fA-F0-9]+)|(\'[a-fA-F0-9]+)|[a-fA-F0-9]+|'A'
id		[A-Za-z]([A-Za-z0-9])*
digit		[0-9]
dec		{digit}+
char		'.'|'\\f'|'\\n'
punc		[\(\),:;]
bool     (true|false)
real    ({digit}+\.{digit}*|\.{digit}+|\d+\.{digit}*)([eE][+-]?{digit}+)?
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
{form}      { ECHO; nextLine(); return('\f'); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"      { ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"&" 	{ ECHO; yylval.oper = AND; return(ANDOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"<>"		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEREQUAL; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"!"		{ ECHO; yylval.oper = NOT; return(NOTOP); }
"=>"		{ ECHO; return(ARROW); }
"^"	    { ECHO; yylval.oper = POWER; return(EXPOP); }
"%"		{ ECHO; yylval.oper = PERCENT; return(REMOP); }
"~"         { ECHO; return(NEGOP); } 
"|"		{ ECHO; yylval.oper = OR; return(OROP); }

begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
if    { ECHO; return(IF); }
then  { ECHO; return(THEN); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }
real     { ECHO; return(REAL); }
not   { ECHO; return(NOTOP);} 
elsif    { ECHO; return(ELSIF); }
else     {  ECHO; return(ELSE); }
endif    { ECHO; return(ENDIF); }
right    { ECHO; return(RIGHT); }
left    { ECHO; return(LEFT); }
fold     { ECHO; return(FOLD); }
endfold     { ECHO; return(ENDFOLD); }
leftfold    { ECHO; return(LEFTFOLD); }
rightfold   { ECHO; return(RIGHTFOLD); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{hex}		{ ECHO; char hex_str[yyleng + 3]; sprintf(hex_str, "0x%s", 
yytext[0] == '#' ? yytext + 1 : yytext); yylval.value = strtol(hex_str, NULL, 16); return(INTEGER); }
{real}		{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{dec}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }

{char}		{ ECHO; yylval.type = CHAR_TYPE; return(CHAR_LITERAL); }
{bool}		{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
