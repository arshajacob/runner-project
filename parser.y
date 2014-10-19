%{
	#include<stdio.h>
	#include<string.h>
	
	#include<iostream>
	#include<fstream>
	#include "Library/SymbolTable.h"
	#include "Library/Preprocessor.h"
	#include "Library/CodeGenerator.h"  //generateCode(10)
	#include "Library/Stack.h"
	
	using namespace std;
	
	Stack control;    //if else
	Stack loop;       // loops
	
	void yyerror(const char *s);
	
%}
%token PRINT READSTRING READCHAR READINT STRING CHAR VAR NUMBER ENDL FUNCTION OB CB RETURN EXIT SHIFTL SHIFTR IF ELSE LOOP IN REF ARRAY
%token EE NE LE GE LA LO
%right '='
%left LO
%left LA
%left '!'
%left '|'
%left '^'
%left '&'
%left '~'
%left EE NE
%left '<' LE '>' GE
%left SHIFTL SHIFTR
%left '+' '-'
%left '*' '/' '%'
%right UMINUS INC DEC
%left '(' ')' '[' ']'
%left ':'
%%

statements: statements statement '\n'
| statements statement ';'
|
;

statement: expression
|exit
|return
|brace
|function
|functionCall
|loop
|if
|else
|print
|printAll 
|readString
|readStringAll
|readChar
|readCharAll
|readInteger
|readIntAll
|arrayDeclaration
|reference
|assignment
|
;

expression: expr { code(30,0); }
;

exit: EXIT	{ code(15,0); }
|EXIT expr	{ code(16,0); }
;

return: RETURN	{ code(17,0); }
|RETURN expr	{ code(18,0); }
;

functionCall: VAR '('')' { int type=sym.getType($1); if(type!=0&&type!=4) yyerror("Incompatible operation attempted on variable name"); code(14,$1); }
;

function: FUNCTION VAR '(' ')' { int type=sym.getType($2); if(type) yyerror("Function name used here is not valid"); sym.setType($2,4,0); control.push($2); control.push(4); } 
;

loop:  loopId expr ':' { control.push(3); }
| loopId expr { control.push(3); }
;

loopId: LOOP	{ code(29,loopCount); loop.push(loopCount++);}
;

if: IF expr ':' { control.push(1);}
|  IF expr { control.push(1);}
;

else: ELSE ':' { control.push(2); }
| ELSE { control.push(2); }
;

brace: OB { int a=control.pop(); if(a==1){ code(23,labelCount); control.push(labelCount++); control.push(a); }
	 else if(a==2){ code(25,labelCount); control.push(labelCount++); control.push(a); }
	 else if(a==3) { code(27,labelCount); control.push(labelCount++); control.push(a); }
	 else if(a==4) { int varid=control.pop(); code(12,varid); control.push(varid); control.push(a); }
	 else { control.push(0); control.push(0); }
	  }
|CB	{ int a=control.pop(); int count=control.pop(); if(a==1){ code(24,count); } else if(a==2){ code(26,count); } else if(a==3){ int lp=loop.pop(); code(28,count,lp); }  else if(a==4){ code(13,count); } }
;

print: PRINT STRING { variableDeclaration(String[$2],$2); if($2==0) macroDefinition(1); code(1,$2);}
| PRINT CHAR { charDeclaration($2); macroDefinition(3); code(9,$2); }
| PRINT expr	{
		if($2==-1)
		{
			code(32,0,0);
		}
		else
		{
			int type=sym.getType($2);
			if (type>20)
				type-=20;
			if(type==0)
				yyerror("Variable: not declared yet");
			else if(type==1)
			{ code(21,$2); macroDefinition(7); }
			else if(type==2)
			{ code(3,$2); macroDefinition(1);}
			else if(type==3)
			{ code(6,$2); macroDefinition(4);}
		}	}
| PRINT ENDL	{ code(4,-1); macroDefinition(1); variableDeclaration("",-1); }
;
printAll: PRINT printString
;
printString: printString STRING  { variableDeclaration(String[$2],$2); if($2==0) macroDefinition(1); code(1,$2);}
|printString CHAR { charDeclaration($2); macroDefinition(3); code(9,$2); }
|printString VAR { int type=sym.getType($2);
		if (type>20)
			type-=20;
		if(type==0)
			yyerror("Variable: not declared yet");
		else if(type==1)
		{ code(21,$2); macroDefinition(7); }
		else if(type==2)
		{ code(3,$2); macroDefinition(1);}
		else if(type==3)
		{ code(6,$2); macroDefinition(4);} }
|printString ENDL { code(4,-1); macroDefinition(1); variableDeclaration("",-1); }
|printString STRING ',' { variableDeclaration(String[$2],$2); if($2==0) macroDefinition(1); code(1,$2);}
|printString CHAR ','{ charDeclaration($2); macroDefinition(3); code(9,$2); }
|printString VAR ',' { int type=sym.getType($2); 
		if (type>20)
			type-=20;
		if(type==0)
			yyerror("Variable: not declared yet");
		else if(type==1)
		{ code(21,$2); macroDefinition(7); }
		else if(type==2)
		{ code(3,$2); macroDefinition(1);}
		else if(type==3)
		{ code(6,$2); macroDefinition(4);} }
|printString ENDL ',' { code(4,-1); }
|STRING ',' { variableDeclaration(String[$2],$2); if($2==0) macroDefinition(1); code(1,$2);}
|CHAR ','  { charDeclaration($2); macroDefinition(3); code(9,$2); }
|expr ',' {
		if($2==-1)
		{
			code(32,0,0);
		}
		else
		{
			int type=sym.getType($2);
			if (type>20)
				type-=20;
			if(type==0)
				yyerror("Variable: not declared yet");
			else if(type==1)
			{ code(21,$2); macroDefinition(7); }
			else if(type==2)
			{ code(3,$2); macroDefinition(1);}
			else if(type==3)
			{ code(6,$2); macroDefinition(4);}
		}	}
|ENDL ',' { code(4,-1); }
;
readString: READSTRING '(' VAR ',' NUMBER ')' { sym.setType($3,2,atoi(Integer[$5])); macroDefinition(2); code(2,$3);}
;
readStringAll: READSTRING readStr
;
readStr: readStr '(' VAR ',' NUMBER ')' { sym.setType($3,2,atoi(Integer[$5])); macroDefinition(2); code(2,$3);}
|readStr '(' VAR ',' NUMBER ')' ',' {  sym.setType($3,2,atoi(Integer[$5])); macroDefinition(2); code(2,$3);}
|'(' VAR ',' NUMBER ')' ',' { sym.setType($2,2,atoi(Integer[$4])); macroDefinition(2); code(2,$2);}
;
readChar: READCHAR VAR { sym.setType($2,3,1); macroDefinition(3); code(5,$2);}
;
readCharAll: READCHAR readCh
;
readCh: readCh VAR { sym.setType($2,3,1); macroDefinition(3); code(5,$2);}
|readCh VAR ',' { sym.setType($2,3,1); macroDefinition(3); code(5,$2);}
|VAR ',' { sym.setType($1,3,1); macroDefinition(3); code(5,$1);}
;
readInteger: READINT VAR { sym.setType($2,1,1); macroDefinition(6); code(20,$2); }
;
readIntAll: READINT readInt
;
readInt: readInt VAR { sym.setType($2,1,1); macroDefinition(6); code(20,$2); }
|readInt VAR ',' { sym.setType($2,1,1); macroDefinition(6); code(20,$2); }
|VAR ',' { sym.setType($1,1,1); macroDefinition(6); code(20,$2); }
;


arrayDeclaration: VAR '=' ARRAY '(' NUMBER ')' { int type=sym.getType($1); if(type) { yyerror("Invalid array assignment. Variable already declared");}
						sym.setType($1,1,atoi(Integer[$5])); }
|VAR '=' NUMBER ARRAY '(' NUMBER ')' { int type=sym.getType($1); if(type) { yyerror("Invalid array assignment. Variable already declared");}
						sym.setType($1,1,atoi(Integer[$6])); }
|VAR '=' CHAR ARRAY '(' NUMBER ')' { int type=sym.getType($1); if(type) { yyerror("Invalid array assignment. Variable already declared");}
						sym.setType($1,3,atoi(Integer[$6])); }
|VAR '=' STRING ARRAY '(' NUMBER ')' { int type=sym.getType($1); if(type) { yyerror("Invalid array assignment. Variable already declared");}
						sym.setType($1,2,atoi(Integer[$6])); }
;

reference: VAR REF VAR { int type=sym.getType($1); if(type) { yyerror("Invalid use of left operand of 'ref'"); } type=sym.getType($3);
			if(type==0) yyerror("Right operand of 'ref' is not declared yet"); else if(type>20) yyerror("Reference of reference is not possible"); 
			sym.setType($1,type+20,0); char name1[30],name2[30];
			sym.getName($1,name1); sym.getName($3,name2); 
			variableDeclaration(name1,-2,name2); }
;

assignment: VAR '=' STRING { sym.setType($1,2,strlen(String[$3])); macroDefinition(5);
				variableDeclaration(String[$3],$3);
				int type1=sym.getType($1);
				if(type1==0||type1==2||type1==3)
				{
					if(type1==0)
						sym.setType($1,2,strlen(String[$3]));
					/*code(7,$3);
					code(8,$1);*/
					code(19,$1,$3);
				}
				else 
					yyerror("Incompatible varible assignment");
			}
|  VAR '=' CHAR { sym.setType($1,3,1); macroDefinition(3); 
		charDeclaration($3);
		int type1=sym.getType($1);
				if(type1==0||type1==3)
				{
					if(type1==0)
						sym.setType($1,3,1);
					code(10,$3);
					code(11,$1);
				}
				else 
					yyerror("Incompatible varible assignment");
			}
;


expr: VAR '=' expr { //sym.setType($1,1,1);
			int type1=sym.getType($1);
			if($3<0)
			{
				if(type1==0||type1==1||type1==21)
				{
					if(type1==0)
						sym.setType($1,1,1);
					code(22,$1);
				}
				else 
					yyerror("Incompatible variable assignment");
			}
			else
			{
				int type2=sym.getType($3);
				if(type1==0||type1==type2||type1==type2+20)
				{
					if(type1==0)
						sym.setType($1,type2,sym.getNoBytes($3));
					if(type2==2)
					{
						macroDefinition(5);
						code(31,$1,$3);
					}
					else
						code(22,$1);
				}
				else 
					yyerror("Incompatible variable assignment");
			}
				$$=-1;
		 }
| VAR '[' expr ']' '=' expr { int type=sym.getType($1); if(type) operations(31,$1,type); else yyerror("Variable not declared yet"); $$=-1; }
| VAR IN '-' '(' expr ',' expr ',' expr ')' { sym.setType($1,1,1); operations(24,$1); $$=-1; }
| VAR IN '-' '(' expr ',' expr ')' { sym.setType($1,1,1); operations(25,$1); $$=-1; }
| VAR IN '(' expr ',' expr ',' expr ')' { sym.setType($1,1,1); operations(22,$1); $$=-1; }
| VAR IN '(' expr ',' expr ')' { sym.setType($1,1,1); operations(23,$1); $$=-1; }
| expr LO expr { cout<<"\nSuccess\n"; $$=-1; }
| expr LA expr { $$=-1; }
| expr '!' expr { $$=-1; }
| expr '|' expr { operations(14); $$=-1; }
| expr '^' expr { operations(15); $$=-1; }
| expr '&' expr { operations(16); $$=-1; }
| '~' expr	{ operations(19); $$=-1; }
| expr EE expr { operations(7); $$=-1; }
| expr NE expr { operations(8); $$=-1; }
| expr GE expr { operations(9); $$=-1; }
| expr '>' expr { operations(10); $$=-1; }
| expr LE expr { operations(11); $$=-1; }
| expr '<' expr { operations(12); $$=-1; }
| expr SHIFTL NUMBER { operations(20,$3); $$=-1; }
| expr SHIFTR NUMBER { operations(21,$3); $$=-1; }
| expr '+' expr { operations(3); $$=-1; }
| expr '-' expr { operations(4); $$=-1; }
| expr '*' expr { operations(5); $$=-1; }
| expr '/' expr { operations(6); $$=-1; }
| expr '%' expr { operations(13); $$=-1; }
| INC expr { if($2<0) { yyerror("Invalid increment operation"); } else{ operations(26,$2); } $$=-1; }
| DEC expr { if($2<0) { yyerror("Invalid decrement operation"); } else{ operations(27,$2); } $$=-1; }
| expr INC { if($1<0) { yyerror("Invalid increment operation"); } else{ operations(28,$1); } $$=-1; }
| expr DEC { if($1<0) { yyerror("Invalid decrement operation"); } else{ operations(29,$1); } $$=-1; }
| '(' expr ')' 
| VAR '[' expr ']' { int type=sym.getType($1); if(type) operations(30,$1,type); else yyerror("Variable not declared yet"); $$=$1; }
| NUMBER { operations(2,$1); $$=-1; }
| VAR { operations(1,$1); $$=$1; }
| '*' VAR { operations(18,$2); $$=$2; }
| '&' VAR { operations(17,$2); $$=$2; }
;

%%

int main(int argc,char *argv[])
{
	if(argc<2)
	{
		cout<<"Usage: "<<argv[0]<<" <input_file> [<output_file>]\nError: No input files specified\n";
		return 1;
	}
	FILE *fp=fopen("Variable.txt","w");
	fclose(fp);
	fp=fopen("Macro.txt","w");
	fclose(fp);
	fp=fopen("Code.txt","w");
	fclose(fp);
	fp=fopen("Uninitialized.txt","w");
	fclose(fp);
	fp=fopen("Procedure.txt","w");
	fclose(fp);
	extern FILE *yyin;
	
	Preprocessor preFile("Preprocessed.txt");
	int err=preFile.fileInclusion(argv[1]);
	preFile.close();
	errors+=err;
	
	if(argc>1)
		yyin=fopen("Preprocessed.txt","r");
	yyparse();
	sym.declare();
	generateCode();
	return errors;
}

void yyerror(const char *s)
{
	errors++;
	fprintf(stderr,"Line %d: Error: %s\n",lineNo,s);
	return;
}
