import BinarySeq
import x86-32/OpCodes
import os/mmap
import structs/HashMap
include errno

TestStruct : class {
    number: Int
    name: String
    init: func (=number, =name) {}
}


genCode: func <T> (funcPtr: Func, closure: T, argSizes: String) -> Pointer { 
    
    op := BinarySeq new(1024)
    op append(OpCodes PUSH_EBP)
    op append(OpCodes MOV_EBP_ESP)
    base := 0x04 
    //+ argSizes length() *4
    for (c: String in argSizes) {
        base += op transTable get(c) as Int
        printf("%d\n", op transTable[c])
    }
    // + argSizes length() * 4 
    for (c: String in argSizes) {
        OpCodes pushCallerArg(op, op transTable[c])
        op append(base& as UChar*, UChar size)
        base -= 0x04
    }
    printf("%d\n\n", base)
    OpCodes pushClosure (op, closure) 
    op append(OpCodes MOV_EBX_ADDRESS)
    op append(funcPtr& as Pointer*, Pointer size)
    op append(OpCodes CALL_EBX)
    op append(OpCodes LEAVE)
    op append(OpCodes RET)

    printf("Code = ")
    op print()
    
    return op data as Func
}

test: func {
    "-- Yay =) This is the test function --" println()
}

test2: func (ptr: Pointer, arg: Int, secArg: Int, thirdArg: Short) -> String {
    printf("Address of param %p, number = %d, name = '%s'\n", ptr, ptr as TestStruct number, ptr as TestStruct name)
    printf("First non-closure arg: %d\n", arg)
    printf("Second arg: %d\n", secArg)
    printf("%d\n", thirdArg)
    return "Oh my god, even return values work!"
}

test3: func(i: Int) -> Int {
    i+i
}

main: func {
    a := TestStruct new(42, "mwahhaha")
    "Generating code.." println()
    code := genCode(test2, a, "iii") as Func -> String
    "Calling code.." println()
    code(24, 8, 18) println() // ATM you can just use DWords
    code2 := genCode(test3, 4, "i") as Func -> Int
    printf("%d\n", code2(2)) 
    "Finished!" println()    
}
