%{
	int lineNo=1;
	int yylex();
	#include "y.tab.c"
	
	#include "Library/StringOperations.h"
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	void replaceEscape(char *);
	void mal2ascii(char *,char *);
	char string1[]="0";
%}


String \"([^"\n])*\"          
Character \'.\'
variable	[a-zA-Z][a-zA-Z0-9_]*
malAlpha1	"അ"|"ആ"|"ഇ"|"ഈ"|"ഉ"|"ഊ"|"ഋ"|"എ"|"ഏ"|"ഐ"|"ഒ"|"ഓ"|"ഔ"|"അം"
malAlpha2	"ക"|"ഖ"|"ഗ"|"ഘ"|"ങ"|"ച"|"ഛ"|"ജ"|"ഝ"|"ഞ"|"ട"|"ഠ"|"ഡ"|"ഢ"|"ണ"|"ത"|"ദ"|"ധ"|"ന"|"പ"|"ഫ"|"ബ"|"ഭ"|"മ"|"യ"|"ര"|"ല"|"വ"|"ശ"|"ഷ"|"സ"|"ഹ"|"ള"|"ഴ"|"റ"|"ക്ഷ"|"ത്ര"|"ക്ക"|"ന്ക"|"ട്ട"|"ണ്ട"
malSym		"ൌ"
malVariable	({malAlpha1}|({malAlpha2}{malSym}?))+
number		[0-9]+
operator	[-+/*%=<>|&~]
comment1	"#".*        
comment2	"/*"(.*\n*)*"*/"
WS		[ \t]
unterminated	\"([^"\n])*|\'[\\]?.*

%%
"print"		{ return PRINT; }
"endl"		{ return ENDL; }
"readString"	{ return READSTRING; }
"readChar"	{ return READCHAR; }
"readInt"	{ return READINT; }
"read"		{ return READINT; }
"function"	{ return FUNCTION; }
"int"		{ strcpy(Integer[integerInd],string1); yylval=integerInd++; return NUMBER; }
"char"		{ Char[charInd]='a'; yylval=charInd++; return CHAR; }
"string"	{ strcpy(String[stringInd],"\"\"");yylval=stringInd++; return STRING; }
"true"		{ strcpy(Integer[integerInd],"1"); yylval=integerInd++; return NUMBER; }
"false"		{ strcpy(Integer[integerInd],"0"); yylval=integerInd++; return NUMBER; }
"ref"		{ return REF; }    //--pointer
"if"		{ return IF; }
"else"		{ return ELSE; }
"loop"		{ return LOOP; }
"in"		{ return IN; }
"return"	{ return RETURN; }
"array"		{ return ARRAY; }
"exit"		{ return EXIT; }
"അച്ചടിക്കുക"	{ return PRINT; }
"പുതിയ വരി"	{ return ENDL; }
"വായിക്കുക"	{ return READINT; }
"അക്ഷരം വായിക്കുക"	{ return READCHAR; }
"സംഖ്യ വായിക്കുക"	{ return READINT; }
"വാക്യം വായിക്കുക"	{ return READSTRING; }
"പ്രവര്ത്തി"	{ return FUNCTION; }
"സംഖ്യ"		{ strcpy(Integer[integerInd],string1); yylval=integerInd++; return NUMBER; }
"അക്ഷരം"		{ Char[charInd]='a'; yylval=charInd++; return CHAR; }
"വാക്യം"		{ strcpy(String[stringInd],"\"\"");yylval=stringInd++; return STRING; }
"ശരി"		{ strcpy(Integer[integerInd],"1"); yylval=integerInd++; return NUMBER; }
"തെറ്റ്"		{ strcpy(Integer[integerInd],"0"); yylval=integerInd++; return NUMBER; }
"ആണെന്കില്‍"	{ return IF; }
"അല്ലെന്കില്‍"	{ return ELSE; }
"ആവറ്ത്തിക്കുക"	{ return LOOP; }
"ല്‍"		{ return IN; }
"തിരികെ നല്കുക"	{ return RETURN; }
"ശ്രേണി"		{ return ARRAY; }
"പുറത്തിറങ്ങുക"	{ return EXIT; }
{variable}	{ yylval=sym.addSymbol(yytext); return VAR; }
{malVariable}	{ char ascii[100]; mal2ascii(yytext,ascii); yylval=sym.addSymbol(ascii); return VAR; }
{number}	{ strcpy(Integer[integerInd],yytext); yylval=integerInd++; return NUMBER; }
"]"		{ return *yytext; }
"["		{ return *yytext; }
"++"		{ return INC; }
"--"		{ return DEC; }
{operator}	{ return *yytext; }
"||"		{ return *yytext; }
"<<"		{ return SHIFTL; }
">>"		{ return SHIFTR; }
"=="		{ return EE; }
"!="		{ return NE; }
"<="		{ return LE; }
">="		{ return GE; }
{String}	{ strcpy(String[stringInd],yytext); replaceEscape(String[stringInd]); yyleng=strlen(yytext); yytext[0]='\0'; yylval=stringInd++; return STRING; }
{Character}	{ Char[charInd]=yytext[1]; yylval=charInd++; return CHAR; }
"{"		{ return OB; }
"}"		{ return CB; }
[\(\),]		{ return *yytext; }
[\n]		{ lineNo++; return *yytext; }
[:;]		{ return *yytext; }
{WS}		{ }
{comment2}	{ }
{comment1}	{ }
{unterminated}	{ yyerror("Unterminated quotes"); }    //[error during lexical analysis]
.		{ yyerror("Unknown token"); }                //[everything elsee]
%%


int yywrap()
{}

void replaceEscape(char *str)
{
	char backSlash[]="\",92,\"";		// \\
	char alert[]="\",7,\"";			// \a
	char backspace[]="\",8,\"";		// \b
	char horizontaltab[]="\",9,\"";		// \t
	char linefeed[]="\",10,\"";		// \n
	char verticaltab[]="\",11,\"";		// \v
	char formfeed[]="\",12,\"";		// \f
	char carriagereturn[]="\",13,\"";	// \r
	char doubleQuote[]="\",34,\"";		// \q
	char singleQuote[]="\",39,\"";		// \'
	
	stringReplace(str,"\\\\",backSlash);
	//stringReplace(str,"\\a",alert);
	stringReplace(str,"\\b",backspace);
	stringReplace(str,"\\t",horizontaltab);
	stringReplace(str,"\\n",linefeed);
	stringReplace(str,"\\ന്",linefeed);
	stringReplace(str,"\\v",verticaltab);
	stringReplace(str,"\\f",formfeed);
	stringReplace(str,"\\r",carriagereturn);
	stringReplace(str,"\\q",doubleQuote);
	stringReplace(str,"\\\'",singleQuote);
}

void mal2ascii(char *mal,char *ascii)
{
	int i,j;
	char alpha[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	ascii[0]='m';
	ascii[1]='_';
	for(i=0,j=2;mal[i]!='\0';i++,j++)
	{
		ascii[j]=alpha[abs(mal[i])%52];
	}
	ascii[j]='\0';
}
