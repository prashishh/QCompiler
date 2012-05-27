
%{

#include <stdio.h>
#include <stdlib.h>
	
extern FILE *fp;

%}


%token SELECT DISTINCT FROM WHERE LE GE EQ NE OR AND LIKE GROUP HAVING ORDER ASC DESC 
%token INSERT INTO VALUES
%token UPDATE SET
%token CREATE TABLE DROP DELETE DT ID NUM  COL DOLLAR
%token GRANT ON TO REVOKE

%right '='
%left AND OR
%left '<' '>' LE GE EQ NE

%start mainprog
%%

mainprog	: DOLLAR ID '=' '"' program '"' COL mainprog
			|  DOLLAR ID '=' '"' program '"' COL
			;
			
program		: S COL program
			| S error COL program
			| S COL	
			| error	
			;


S			: ST1 
			| ST11 
			| ST12 
			| ST13 
			| ST14 
			| ST15 
			| ST16
			| ST17
			;

 
	ST1    :  CREATE TABLE tablename '('newList')'
			| CREATE error { printf("\tTABLE keyword missing\n"); }
		;


	ST11	: SELECT attributeList FROM tablename ST2
			| SELECT DISTINCT attributeList FROM tableList ST2 
			| SELECT attributeList error { printf("\tFROM keyword missing\n"); }
			| SELECT attributeList FROM error { printf("\ttable name missing\n"); }
		;	


	ST12	: INSERT INTO tablename VALUES '('attributeList')' 
			| INSERT INTO tablename '('coloumnList')' VALUES '('attributeList')'
			| INSERT error { printf("\tINTO/VALUES keyword missing\n"); }
			| INSERT INTO tablename error { printf("\tVALUES keyword missing\n"); }


			;

	ST13	: UPDATE tablename SET ECOND WHERE ECOND
	 		| UPDATE error { printf("\ttablename missing\n"); }
	 		| UPDATE tablename error { printf("\tSET/WHERE keyword missing\n"); }
	 		| UPDATE tablename SET error { printf("\tCondition parameter incorrect\n"); }
			;

	ST14	:  DELETE attributeList FROM tablename ST2
			| DELETE FROM tablename ST2
	 		| DELETE attributeList error { printf("\tFROM keyword missing\n"); }
	 		| DELETE error { printf("\tdelete attributes missing\n"); }
	 		| DELETE attributeList FROM error { printf("\tablename missing\n"); }

			;

	ST15	: DROP TABLE tablename  
	 		| DROP error { printf("TABLE keyword missing\n"); }
	 		| DROP TABLE error { printf("tablename missing\n"); }
			;
			
	ST16 : GRANT privilege_name ON tableList TO username 
    		| GRANT error { printf("ON/TO keyword missing\n"); }
			;
			
	ST17 : 	REVOKE privilege_name ON tableList FROM username 
		 	| REVOKE error { printf("ON/FROM keyword missing\n"); }

			;

    ST2     : WHERE COND ST3
               | ST3
               ;
    ST3     : GROUP attributeList ST4
               | ST4
               ;
    ST4     : HAVING COND ST5
               | ST5
               ;
    ST5     : ORDER attributeList ST6
               |
               ;
    ST6     : DESC
               | ASC
               |
               ;

newList 	: ID DT'('NUM')'
			| ID DT'('NUM')'','newList
			; 
    
attributeList : ID','attributeList { STK12(); }
  		| NUM',' attributeList { STK12(); }
  		| ID { STK12(); }
		| NUM  { STK12(); }
		|'"'attributeList'"' { STK12(); }
		| '"'attributeList'"'','attributeList { STK12(); }
        | '*'
		;

tableList    : ID',' tableList { STK11(); }
               | ID { STK11(); }
               ;

coloumnList :  ID','coloumnList { STK11(); }
		| ID { STK11(); }
		; 

tablename : ID
		;

COND    : COND OR COND
               | COND AND COND
               | E
               ;

ECOND  : ECOND','G
		| G	
		;

username : ID
		| ID','username
		;

privilege_name : ID
			| ID',' privilege_name
			| '*'
			;
			
E         : F '=' F
			| F '=''"'F'"'
               | F '<' F
               | F '>' F 
               | F LE F
               | F GE F
               | F EQ F
               | F NE F
               | F OR F
               | F AND F
               | F LIKE F
               ;

G		: F '=' F
		| F '=''"'F'"'
		;

F       : ID
		| NUM
		;




%%
#include "lex.yy.c"
#include <ctype.h>

int count = 0;
int array[100], pos,;


int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	
   if(!yyparse())
		printf("\nSQL parsing complete\n");
	else
		printf("\nSQL parsing failed\n");
	
	fclose(yyin);
    return 0;
}          


STK11() {
	count++;
}

STK12() {
	count--;
}

Error() {

	if ( count != 0 ) {
		printf("Variable and Attribute number mismatch\n");
	}
	else {}
}

yyerror(char *s)
{
	printf("%d: %s at %s\n", yylineno, s, yytext);
	Error();
}

yywrap(){
	
}
