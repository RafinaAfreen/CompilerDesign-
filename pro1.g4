grammar pro1;
root: declaration function+ ;
declaration:('^^' declarationlist ('<' declarationtype '>'|declarationtype))+ ;
declarationlist : 'include' | 'define' | 'import' ;
declarationtype: term '.' term| expression+;

function :((ID|type ID) '(' ')' inner_part) |( (ID|type ID) '(' type variable ')' (';')?(inner_part)? ) |( (ID|type ID) '(' (type variable ',' type variable)+ ')' (';')? (inner_part)? ) ;
inner_part: '^<' information '>^';
information:
(
about_expr
| if_else
| return_
| iteration
| output
| breakset
| scan_
| functioncall
| switch_case
)+
;
about_expr: (type term+ ((','term+)+)?) ';'|(type)? term'$=' term('['term']')?(','(variable|term'$=' term))?';'|(type)? (term+ '[' term ('_'term)? ']'(',')?)+(','(variable|term'$=' term))?';'|term+'['term']' rel_op (term+'['term']'|symbol term symbol) ';'|term variable_inc_dec ';'|(type)? term+ rel_op functioncall ';'| (type)?term+ rel_op term bin_op term ';' ;
return_: 'return' expression ';' | 'return' term ';'| 'return' (expression+)? functioncall ';' ;
expression :symbol+|term+|expression bin_op expression |expression rel_op expression |expression logic_op expression|term (term',')+ term | expression rel_op term|term '['term']'rel_op term|term bin_op term rel_op term|term+('['term']')? rel_op (symbol)? term (symbol)?;
symbol: '*' | '@' | '!' |'-' |'_' |'~'| '/'|'?'|';'|'"'| ','| '.'|':';
bin_op:'$+' | '$-' | '$*' | '$/' | '$%';
rel_op:'$=' | '$!=' | '$>' | '$>=' | '$<' | '$<='|'$==';
logic_op:  '$||' | '$&&' ;
if_else: 'if' '^<' expression ((logic_op expression+)+)? '>^'inner_part | 'if' '^<' expression ((logic_op expression+)+)? '>^' inner_part 'else' inner_part| 'if' '^<' expression ((logic_op expression+)+)? '>^' inner_part 'else if' '^<' expression ((logic_op expression+)+)? '>^' inner_part | 'if' '^<' expression ((logic_op expression+)+)?'>^' inner_part 'else if' '^<'expression ((logic_op expression+)+)?'>^' inner_part 'else' inner_part ;
breakset: 'break'';' | 'continue' ';' ;
switch_case : 'switch' '(' expression+ ')' '^<' switchblock '>^' ;
switchblock : ('case' term ':' inner_part )+ ('default' ':' inner_part)?;
iteration: condition | loop;
condition: 'while' '^<' expression+'>^' inner_part;
loop: 'for' '^<' (type)? variable '$=' term ';' variable rel_op term ';' (variable variable_inc_dec|variable_inc_dec variable) '>^' inner_part;
output: 'print' '^<' expression ':' '>^' ';'| 'print' '^<' bin_op type (expression)? ':' variable('['variable']')? '>^' ';'|'print' '^<' expression+ '>^' ';'|'print' '^<' expression+ (rel_op)? bin_op type (expression+)? (rel_op)? (bin_op type)? ':' expression+ (functioncall)? '>^' ';' | 'print' '^<' (expression bin_op type)+ ':' expression '>^'';'|'print' '^<' expression bin_op type term+ bin_op type ':' expression functioncall '>^' ';'|'print' '^<'bin_op type expression+ ':' expression+ '>^'';';
scan_: 'scan'  '^<' (bin_op type)+ ':' ('$'term+)+ ('['variable']')?'>^' ';'|'gets''^<'term+'>^'';';
functioncall: variable '(' ')'(';')?|  variable '(' (expression+)? ')'(';')? ;
variable: ID;
variable_inc_dec:'$++'| '$--';
term:ID|LIT ;
type: 'integer'|'double'|'boolian'|'char';

ID : [a-zA-Z]+ ;
LIT : [0-9]+ ;

WS : [ \t\r\n]+ ->skip;