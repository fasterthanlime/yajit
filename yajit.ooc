import BinarySeq
import x86-32.OpCodes

genCode: func (funcPtr: Func, arg: Int) -> Func {
	

    //blub := new BinarySeq(1, [arg as UChar]) doesn't work!
    op := new BinarySeq(1000)
 	
	op += OpCodes PUSH_EBP
	op += OpCodes MOV_EBP_ESP
	op += OpCodes PUSH_BYTE
    op += OpCodes TEST
    op += OpCodes MOV_EBX_ADDRESS
	op += funcPtr as Pointer
	op += OpCodes CALL_EBX
	op += OpCodes LEAVE
	op += OpCodes RET

	op print()
	return op data as Func
}

test: func {
	"-- Yay =) This is the test function --" println()
}

test2: func (a: Int){
    printf("%d\n", a)
}

main: func {
	"Generating code.." println()
    code = genCode(test2, 2) : Func
	"Calling code.." println()
	code()
	"Finished!" println()	
}
