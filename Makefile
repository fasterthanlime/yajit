.PHONY: all clean
 
all:
	ooc tests/test_partial -o=tests/test_partial -gcc -D_BSD_SOURCE -driver=sequence  -g -shout -v -noclean
 
clean:
	rm -rf ooc_tmp
 
