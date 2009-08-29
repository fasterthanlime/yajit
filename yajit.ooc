import BinarySeq
import x86-32.OpCodes

printf: extern Func

genCode: func (funcPtr: Func) -> Func (String) {
	op := new BinarySeq(1000)
	
	op += OpCodes PUSH_EBP
	op print()
	op += OpCodes MOV_EBP_ESP
	op print()
	op += OpCodes PUSH_ADDRESS
	op print()
	op += funcPtr as Pointer
	op print()
	op += OpCodes CALL_EBX
	op print()
	op += OpCodes LEAVE
	op print()
	op += OpCodes RET

	op print()
	return op data
}

test: func {
	"Yay =)" println()
}


main: func {
	"Generating code.." println()
	code = genCode(test) : Func
	"Calling code.." println()
	code()
	"Finished!" println()	
}
