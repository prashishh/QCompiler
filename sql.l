%{
%}

alpha [a-zA-Z]
digit [0-9]
html  <.*>
%%
[ \t]			{}
[ \n]   { yylineno = yylineno + 1;}
{html} 			;
select            return SELECT;
create 		return CREATE;	
drop		return DROP;
table 		return TABLE;
distinct         return DISTINCT;
from             return FROM;
where           return WHERE;
like               return LIKE;
desc              return DESC;
asc                return ASC;
grant 		return GRANT;
on 			return ON;
to 			return TO;
revoke		return REVOKE;
"group by"    return GROUP;
having          return HAVING;
"order by"    return ORDER;
or                 return OR;
and               return AND;
insert 		return INSERT;
into		return INTO;
values 		return VALUES;
update      return UPDATE;
delete 		return DELETE;
set         return SET;
varchar   	return DT;
number 		return DT;
float 		return DT;
{digit}+       return NUM;
{alpha}({alpha}|{digit})* return ID;
"<="             return LE;
">="             return GE;
"=="             return EQ;
"!="              return NE;
";"				return COL;
"$"				return DOLLAR;
.            return yytext[0];
%%
