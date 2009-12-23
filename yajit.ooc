import BinarySeq
import x86-32/OpCodes
import os/mmap
import structs/[ArrayList,HashMap]
include errno


Cell: class <T>{
    val :T
    init: func(=val) {}
}

TestStruct : class {
    number: Int
    name: String
    init: func (=number, =name) {}
}

pushNonClosureArgs: func(op: BinarySeq, argSizes: String, base: Int) -> BinarySeq {
    for (c: Char in argSizes) {
        s := String new(c)
        OpCodes pushCallerArg(op, op transTable[s])
        op append(base& as UChar*, UChar size)
        base = base - 0x04 //op transTable get(s)
    }
    return op
}

initSequence: func(s: Int) -> BinarySeq {
    op := BinarySeq new(s)
    op append(OpCodes PUSH_EBP)
    op append(OpCodes MOV_EBP_ESP)
    return op
}

finishSequence: func(op: BinarySeq, funcPtr: Func) -> BinarySeq {
    op append(OpCodes MOV_EBX_ADDRESS)
    op append(funcPtr& as Pointer*, Pointer size)
    op append(OpCodes CALL_EBX)
    op append(OpCodes LEAVE)
    op append(OpCodes RET)
}

genCode: func <T>(funcPtr: Func, closure: T, argSizes: String) -> Pointer {
    op := initSequence(1024)
    base := 0x04
    for (c: Char in argSizes) {
        s := String new(c)
        base = base + 0x04
    }
    op = pushNonClosureArgs(op, argSizes, base)
    op = finishSequence(op, funcPtr)
    return op
}
   

genCode: func  ~argList(funcPtr: Func, closure: ArrayList<Cell<Pointer>>, argSizes: String) -> Pointer { 
    // even if a non-closure arg is smaller than 4 byte
    // treating it as it'd have 4 bytes works
    // should be fixed later on, but it's currently
    // more important to have somehing working :) 
    op := initSequence(1024)
    base := 0x04 * closure size()   
    for (c: Char in argSizes) {
        s := String new(c)
        base = base + 0x04 //op transTable get(s) 
    }
    op = pushNonClosureArgs(op, argSizes, base)
    //printf("\n%d\n\n", base)
    for (item: Cell<Pointer> in closure) {
        OpCodes pushClosure (op, item val)
    } 
    op = finishSequence(op, funcPtr)
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

test3: func(i, j, k: Int) -> Int {
    i+j
}

main: func {
    a := TestStruct new(42, "mwahhaha")
    "Generating code.." println()
    cl_arg1 := Cell<Int> new(27)
    cl_arg2 := Cell<Short> new(42)
    closure_args := ArrayList<Cell<Pointer>> new()
    closure_args add(cl_arg1).add(cl_arg2)
    code := genCode(test2, closure_args, "iii") as Func -> String
    "Calling code.." println()
    code(24, 8, 18 as Char) println() // You can use anything <= 4 byte
    code2 := genCode(test3, 4, "i") as Func -> Int
    printf("%d\n", code2(2)) 
    "Finished!" println()    
}
