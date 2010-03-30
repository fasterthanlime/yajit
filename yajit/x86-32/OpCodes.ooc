import BinarySeq

OpCodes: class  {
    
    PUSH_EBP := static const BinarySeq new(1, [0x55 as UChar]) 
    PUSH_BYTE := static const BinarySeq new(1, [0x6a as UChar]) 
    PUSH_WORD := static const BinarySeq new(2, [0x66 as UChar, 0x68])
    PUSH_DWORD := static const BinarySeq new(1, [0x68 as UChar])
    PUSHW_EBP_VAL := static const BinarySeq new(3, [0x66 as UChar, 0xff, 0x75])
    PUSHDW_EBP_VAL := static const BinarySeq new(2, [0xff as UChar, 0x75])
    MOV_EBP_ESP := static const BinarySeq new(2, [0x89 as UChar, 0xe5])
    MOV_EBX_ADDRESS := static const BinarySeq new(1, [0xbb as UChar])
    MOV_EBX_EBP_PLUS_8 := static const BinarySeq new(3, [0x8b as UChar, 0x5d, 0x08])
    PUSH_EBX := static const BinarySeq new(1, [0x53 as UChar])
    PUSH_ADDRESS := static const BinarySeq new(1, [0x68 as UChar])
    CALL_ADDRESS := static const BinarySeq new(1, [0xe8 as UChar])
    CALL_EBX := static const BinarySeq new(2, [0xff as UChar, 0xd3])
    LEAVE := static const BinarySeq new(1, [0xc9 as UChar])
    RET := static const BinarySeq new(1, [0xc3 as UChar])
}
/*
Partial: class {
    
    funcPtr: Func
    argSizes := ""
    bseq: BinarySeq
    init: func(=funcPtr) {initSequence(1024)}
    
    getBase: func(argSizes: String, bseq: BinarySeq) -> Int{
        base := 0x04
        for (c: Char in argSizes) {
            base = base + bseq transTable get(String new(c))
        }
    return base
    }
    
    pushNonClosureArgs: func(base: Int)  {
        for (c: Char in argSizes) {
            s := String new(c)
            OpCodes pushCallerArg(bseq, op transTable[s])
            bseq append(base& as UChar*, UChar size)
            base = base - bseq transTable get(s) //op transTable get(s)
        }
        printf("EndBase: %d\n", base)
        "pushNonClosureArgs: " println()
        bseq print()
        "" println()
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

    
    
}
*/
