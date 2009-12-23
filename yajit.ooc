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

pushNonClosureArgs: func(op: BinarySeq, argSizes: String, base: Int)  {
    for (c: Char in argSizes) {
        s := String new(c)
        OpCodes pushCallerArg(op, op transTable[s])
        op append(base& as UChar*, UChar size)
        base = base - 0x04 //op transTable get(s)
    }
    printf("EndBase: %d\n", base)
    "pushNonClosureArgs: " println()
    op print()
    "" println()
    
}

initSequence: func(s: Int) -> BinarySeq {
    op := BinarySeq new(s)
    op append(OpCodes PUSH_EBP)
    op append(OpCodes MOV_EBP_ESP)
    "Init sequence: " print()
    op print()
    "" println()
    return op
}

finishSequence: func(op: BinarySeq, funcPtr: Func)  {
    op append(OpCodes MOV_EBX_ADDRESS)
    op append(funcPtr& as Pointer*, Pointer size)
    op append(OpCodes CALL_EBX)
    op append(OpCodes LEAVE)
    op append(OpCodes RET)
}

genCode: func <T>(funcPtr: Pointer, closure: T, argSizes: String) -> Pointer {
    op := initSequence(1024)
    base := 0x04 + argSizes length() * 4
    pushNonClosureArgs(op, argSizes, base)
    OpCodes pushClosure(op, closure)
    finishSequence(op, funcPtr)
    op print()
    return op data as Func
}
   

genCode: func  ~argList(funcPtr: Pointer, closure: ArrayList<Cell<Pointer>>, argSizes: String) -> Pointer { 
    // even if a non-closure arg is smaller than 4 byte
    // treating it as it'd have 4 bytes works
    // should be fixed later on, but it's currently
    // more important to have somehing working :) 
    op := initSequence(1024)
    base := 0x04 + argSizes length() * 4
    /*
    for (c: Char in argSizes) {
        s := String new(c)
        base = base + 0x04 //op transTable get(s) 
    }
    */
    printf("StartBase: %d\n", base)
    pushNonClosureArgs(op, argSizes, base)
    //printf("\n%d\n\n", base)
    for (item: Cell<Pointer> in closure) {
        T := item T
        OpCodes pushClosure (op, item val as T)
    } 
    finishSequence(op, funcPtr)
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
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    printf("k:%d\n", k)
    i+j
}

test4: func(i, j: Int) -> Int {
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    i+j
}

test5: func(i, j: Int, tStruct: TestStruct, k: Int) -> Int {
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    printf("k:%d\n", k)
    printf("Address of param %p, number = %d, name = '%s'\n", i, i as TestStruct number, i as TestStruct name)
    i+j+k
}

main: func {
    a := TestStruct new(42, "mwahhaha")
    "Generating code.." println()
    clArg1 := Cell<Int> new(21)
    clArg2 := Cell<Int> new(42)
    clArg3 := Cell<Pointer> new(a)
    closureArgs := ArrayList<Cell<Pointer>> new()
    closureArgs add(clArg1).add(clArg2).add(clArg3)
    
    code := genCode(test2, a, "iii") as Func -> String
    "Calling code.." println()
    code(24, 8, 18 as Char) println() // You can use anything <= 4 byte
    code2 := genCode(test3, 4, "ii") as Func -> Int
    printf("%d\n", code2(2, 2)) 
    code3 := genCode(test4, closureArgs, "") as Func -> Int
    code3()
    code4 := genCode(test5, closureArgs, "i") as Func -> Int
    code4(23)
    "Finished!" println()    
}
