%{
// Эти объявления добавляются в класс GPPGParser, представляющий собой парсер, генерируемый системой gppg
    public BlockNode root; // Корневой узел синтаксического дерева 
    public Parser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
%}
 
%output = SimpleYacc.cs
 
%union { 
	public int iVal; 
	public string sVal; 
	public Node nVal;
	public ExprNode eVal;
	public StatementNode stVal;
	public BlockNode blVal;
	public PrintNode prVal;
	public ExprListNode elVal;
	public GoToNode gtNode;
	public LabelNode lbNode;
       }
 
%using Compiler.Parser.AST;
 
%namespace Compiler.Parser
 
%token BEGIN END CYCLE ASSIGN SEMICOLON OPENBR CLOSEBR COMMA PRINT FOR PLUS MINUS MULT DIV IF ELSE GT LT GE LE EQ NEQ NOT GOTO COLON
%token <iVal> INUM 
%token <sVal> ID

%type <eVal> expr ident W T F 
%type <stVal> assign statement cycle for if 
%type <blVal> stlist block
%type <prVal> print
%type <elVal> exprlist
 
%%

progr   : block { root = $1; }
		;
		
		
stlist	: statement 
			{ 
				$$ = new BlockNode($1); 
			}
		| stlist statement 
			{ 
				$1.Add($2); 
				$$ = $1; 
			}
		;

statement: ident COLON statement { $$ = new LabelNode($1 as IdNode, $3); }
		| GOTO ident SEMICOLON { $$ = new GoToNode($2 as IdNode); }
		| assign SEMICOLON { $$ = $1; }
		| cycle { $$ = $1; }
		| for { $$ = $1; }
		| print SEMICOLON { $$ = $1; }
		| if { $$ = $1; }
		| block  { $$ = $1; }
		| { $$ = new EmptyNode(); }
		;

ident 	: ID { $$ = new IdNode($1); }	
		;
	
assign 	: ident ASSIGN expr { $$ = new AssignNode($1 as IdNode, $3); }
		;
		
expr : W  { $$ = $1; }
     | expr LT W { $$ = new BinaryNode($1, $3, "<"); }
     | expr GE W { $$ = new BinaryNode($1, $3, ">"); }
     | expr LE W { $$ = new BinaryNode($1, $3, "<="); }
     | expr GT W { $$ = new BinaryNode($1, $3, ">="); }
     | expr EQ W { $$ = new BinaryNode($1, $3, "=="); }
     | expr NEQ W { $$ = new BinaryNode($1, $3, "!="); }
     ; 

W    : T { $$ = $1; }
     | expr PLUS T { $$ = new BinaryNode($1, $3, "+"); }
     | expr MINUS T { $$ = new BinaryNode($1, $3, "-"); }
     ;

T    : F { $$ = $1; }
     | T MULT F { $$ = new BinaryNode($1, $3, "*"); }
     | T DIV F { $$ = new BinaryNode($1, $3, "/"); }
     ;

F    : MINUS ident { $$ = new UnaryNode($2, '-');}
     | MINUS INUM { $$ = new UnaryNode($2, '-');}
     | NOT ident { $$ = new UnaryNode($2, '!');}
     | NOT INUM { $$ = new UnaryNode($2, '!');}
	 | ident { $$ = $1 as IdNode; }
     | INUM { $$ = new IntNumNode($1); }
     | OPENBR expr CLOSEBR { $$ = $2; }
     | MINUS OPENBR expr CLOSEBR { $$ = new UnaryNode($3, '-');}
     | NOT OPENBR expr CLOSEBR { $$ = new UnaryNode($3, '!');}
     ;

block	: BEGIN stlist END { $$ = $2; }
		;

cycle	: CYCLE OPENBR expr CLOSEBR block  { $$ = new CycleNode($3, $5); }
		;

for 	: FOR OPENBR assign COMMA expr COMMA expr CLOSEBR block { $$ = new ForNode($3 as AssignNode, $5, $7, $9); }
		| FOR OPENBR assign COMMA expr CLOSEBR block { $$ = new ForNode($3 as AssignNode, $5, $7); }
		;
		
exprlist: expr 
			{ 
				$$ = new ExprListNode($1); 
			}
		| exprlist COMMA expr
			{ 
				$1.Add($3); 
				$$ = $1; 
			}
		;
		
print   : PRINT OPENBR exprlist CLOSEBR { $$ = new PrintNode($3); }
		;

if		: IF OPENBR expr CLOSEBR block ELSE block { $$ = new IfNode($3, $5, $7); }
		| IF OPENBR expr CLOSEBR block { $$ = new IfNode($3, $5); }
		;
%%
