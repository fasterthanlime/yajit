import structs/ArrayList
import ../BinarySeq
import OpCodes

Partial: class {     
    
    bseq: BinarySeq

    init: func {initSequence(1024)}
    init: func ~withSize(s: Int) {initSequence(s)}
    
    pushClosure: func <T> (arg: T) {
        match T size {
            case 1 => bseq append(OpCodes PUSH_BYTE)
            case 2 => bseq append(OpCodes PUSH_WORD)
            case 4 => bseq append(OpCodes PUSH_DWORD)
            case => {fprintf(stderr, "Trying to push unknown size: %d\n", T size)
                 x := 0
                 x = 10 / x // dirty way of throwing an exception
                }
        }
        bseq append(arg&, T size)
    }

    pushCallerArg: func <T> (arg: T) {
        match T size {
            case 1 || 2 => bseq += OpCodes PUSHW_EBP_VAL
            case 4 => bseq += OpCodes PUSHDW_EBP_VAL
            case =>{fprintf(stderr, "Trying to push unknown size: %d\n", T size)
                 x := 0
                 x = 10 / x // dirty way of throwing an exception
                }
        } 
    }
    
    genCode: func <T>(function: Pointer, closure: T, argSizes: String) -> Pointer {
        pushNonClosureArgs(getBase(argSizes, bseq), argSizes)
        pushClosure(closure)
        finishSequence(function)
        bseq print()
        return bseq data as Func
    }
    
    genCode: func ~multipleArgs(function: Pointer, closure: ArrayList<Cell<Pointer>>, argSizes: String) -> Pointer { 
        // IMPORTANT!! bug concerning choice of right polymorphic func
        // even if a non-closure arg is smaller than 4 byte
        // treating it as it'd have 4 bytes works
        // should be fixed later on, but it's currently
        // more important to have somehing working :) 
        bseq := initSequence(1024)
        //closureArgs := closure clone() // cloning fixes problem with reverse (don't ask why^^)
        //closureArgs reverse()
        pushNonClosureArgs(getBase(argSizes, bseq),argSizes)
        for (item: Cell<Pointer> in closure) {
            T := item T
            pushClosure(item val as Pointer)
        } 
        finishSequence(function)
        printf("Code = ")
        bseq print()
        return bseq data as Func
    }
    
    initSequence: func(s: Int) -> BinarySeq {
        bseq = BinarySeq new(s)
        bseq append(OpCodes PUSH_EBP)
        bseq append(OpCodes MOV_EBP_ESP)
        "Init sequence: " print()
        bseq print()
        "" println()
        return bseq
    }
    
    pushNonClosureArgs: func(base: Int, argSizes: String)  {
        for (c: Char in argSizes) {
            s := String new(c)
            pushCallerArg(bseq transTable get(s))
            bseq append(base& as UChar*, UChar size)
            base = base - bseq transTable get(s) //op transTable get(s)
        }
        printf("EndBase: %d\n", base)
        "pushNonClosureArgs: " println()
        bseq print()
        "" println()
    }

    finishSequence: func(funcPtr: Pointer) {
        bseq append(OpCodes MOV_EBX_ADDRESS)
        bseq append(funcPtr& as Pointer*, Pointer size)
        bseq append(OpCodes CALL_EBX)
        bseq append(OpCodes LEAVE)
        bseq append(OpCodes RET)
    }

    converseFloat: static func(f: Float) -> Int {(f& as Int32*)@}
    getBase: func(argSizes: String, bseq: BinarySeq) -> Int{
        base := 0x04
        for (c: Char in argSizes) {
            base = base + bseq transTable get(String new(c))
        }
        return base
    }

}

