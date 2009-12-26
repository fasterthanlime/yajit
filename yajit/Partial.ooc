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

reverse: func <T> (list: ArrayList<T>) {
    "i'm reversed" println()
    i := 0
    j := list size() -1
    tmp: T
    while (i <= j / 2) {
        tmp = list[i]
        list[i] = list[j]
        list[j] = tmp
        i += 1
        j -= 1
    }
}

Partial: class {
    
    funcPtr: Func
    argSizes := ""
    op: BinarySeq
    init: func(=funcPtr) {initSequence(1024)}
    
    getBase: func(argSizes: String, op: BinarySeq) -> Int{
        base := 0x04
        for (c: Char in argSizes) {
            base = base + op transTable get(String new(c))
        }
    return base
    }
    
    pushNonClosureArgs: func(base: Int)  {
        for (c: Char in argSizes) {
            s := String new(c)
            OpCodes pushCallerArg(op, op transTable[s])
            op append(base& as UChar*, UChar size)
            base = base - op transTable get(s) //op transTable get(s)
        }
        printf("EndBase: %d\n", base)
        "pushNonClosureArgs: " println()
        op print()
        "" println()
    }
    converseFloat: static func(f: Float) -> Int {(f& as Int32*)@}
   
    initSequence: func(s: Int) -> BinarySeq {
        op = BinarySeq new(s)
        op append(OpCodes PUSH_EBP)
        op append(OpCodes MOV_EBP_ESP)
        "Init sequence: " print()
        op print()
        "" println()
        return op
    }

    finishSequence: func  {
        op append(OpCodes MOV_EBX_ADDRESS)
        op append(funcPtr& as Pointer*, Pointer size)
        op append(OpCodes CALL_EBX)
        op append(OpCodes LEAVE)
        op append(OpCodes RET)
    }

    genCode: func <T>(closure: T) -> Pointer {
        pushNonClosureArgs(getBase(argSizes, op))
        OpCodes pushClosure(op, closure)
        finishSequence()
        op print()
        return op data as Func
    }

    setNonPartialArgs: func(=argSizes) {}
    
    genCode: func ~argList(closure: ArrayList<Cell<Pointer>>) -> Pointer { 
        // IMPORTANT!! bug concerning choice of right polymorphic func
        // even if a non-closure arg is smaller than 4 byte
        // treating it as it'd have 4 bytes works
        // should be fixed later on, but it's currently
        // more important to have somehing working :) 
        printf("\n%daaa\n\n", closure size())
        op := initSequence(1024)
        closureArgs := closure clone() // cloning fixes problem with reverse (don't ask why^^)
        reverse(closureArgs)
        pushNonClosureArgs(getBase(argSizes, op))
        for (item: Cell<Pointer> in closureArgs) {
            T := item T
            OpCodes pushClosure (op, item val as T)
        } 
        finishSequence()
        printf("Code = ")
        op print()
        return op data as Func
    }
}

