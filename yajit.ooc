import BinarySeq
import x86-32.OpCodes

TestStruct : class {
	number: Int
	name: String
	init: func (=number, =name) {}
}

genCode: func <T> (funcPtr: Func, closure: T, argSizes: Int[], argLen: Int) -> Func { 
	
    op := BinarySeq new(1024)
	op += OpCodes PUSH_EBP
	op += OpCodes MOV_EBP_ESP
    
    base := 0x04 + argLen * 4  
    //printf("%d\n", base)
    for(i: Int in 0..argLen) {
    
        t := argSizes[i]
        OpCodes pushCallerArg(op, t)
        op += base as UChar
        base -= 0x04
        
    }
        
    OpCodes pushClosure (op, closure) 
	op += OpCodes MOV_EBX_ADDRESS
	op += funcPtr as Pointer
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

test2: func (ptr: Pointer, arg: Int, secArg: Int, thirdArg: Short){
    printf("Address of param %p, number = %d, name = '%s'\n",
		ptr, ptr as TestStruct number, ptr as TestStruct name)
    printf("First non-closure arg: %d\n", arg)
    printf("Second arg: %d\n", secArg)
    printf("%d\n", thirdArg)
    
}

main: func {
    a := TestStruct new(42, "mwahhaha")
    //printf("%x\n", a as Pointer)
    
    sizes := [4 as Int, 4, 4] 
    "Generating code.." println()
    code := genCode(test2, a as Pointer, sizes, 3) 
	"Calling code.." println()
    code(24, 8, 18) // ATM you can just use DWords
	"Finished!" println()	
}
