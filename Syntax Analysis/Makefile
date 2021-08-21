output: parser.y flex.l
	flex flex.l
	gcc -c hashtable/hashtbl.c 
	bison -v -d parser.y
	gcc parser.tab.c lex.yy.c hashtable/hashtbl.c -lm

flex: flex.l
	flex flex.l

bison: parser.y
	bison -v -d parser.y

run: 
	./a.out Tests/test1.txt

test: Tests/test.c
	gcc Tests/test.c -std=c99 -o out

testclean: out
	rm out

clean: 
	rm lex.yy.c parser.tab.c parser.tab.h parser.output a.out