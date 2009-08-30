import BinarySeq
import x86-32.OpCodes


TestStruct : class {
	number: Int
	name: String
	new: func (=number, =name)
}

genCode: func <T> (funcPtr: Func, arg: T) -> Func {
	
	toodizoo := new BinarySeq(10, [0x12 as UChar]) // <- showstopper hey look, it works =)
	
    op := new BinarySeq(1024)
    op += OpCodes PUSH_EBP
	op += OpCodes MOV_EBP_ESP
	
	OpCodes push (op, arg) // go see the code, it's pretty =)
	
	op += OpCodes MOV_EBX_ADDRESS
	op += funcPtr as Pointer // cast because C doesn't like sizeof(void (*)())
	op += OpCodes CALL_EBX
	op += OpCodes LEAVE
	op += OpCodes RET

	printf("Code = ")
	op print()
	return op data as Func

}



    
test: func {
	"-- Yay =) This is the test function --" println()
}

test2: func (ptr: Pointer){
    printf("Address of param %p, number = %d, name = '%s'\n",
		ptr, ptr as TestStruct number, ptr as TestStruct name)
}

main: func {
    
    a := new TestStruct(42, "mwahhaha")
    printf("%x\n", a as Pointer)
    "Generating code.." println()
    code := genCode(test2, a as Pointer) 
	"Calling code.." println()
    code()
	"Finished!" println()	
	
}
