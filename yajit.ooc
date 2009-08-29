import BinarySeq
import x86-32.OpCodes

genCode: func (funcPtr: Func) -> Func {
	op := new BinarySeq(1000)
	
	op += OpCodes PUSH_EBP
	op += OpCodes MOV_EBP_ESP
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


main: func {
	"Generating code.." println()
	code = genCode(test) : Func
	"Calling code.." println()
	code()
	"Finished!" println()	
}
