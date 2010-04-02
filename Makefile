.PHONY: all clean
 
all:
	rock tests/test_partial  -o=tests/test_partial -D_BSD_SOURCE -driver=sequence  -g -shout -v -noclean 
 
clean:
	rm -rf rock_tmp
 
