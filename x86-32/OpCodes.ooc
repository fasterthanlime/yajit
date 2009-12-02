import BinarySeq

OpCodes: class {

init : func {}

PUSH_EBP 			:= static const BinarySeq new(1, [0x55 as UChar]) 
PUSH_BYTE           := static const BinarySeq new(1, [0x6a as UChar]) 
PUSH_WORD           := static const BinarySeq new(2, [0x66 as UChar, 0x68])
PUSH_DWORD          := static const BinarySeq new(1, [0x68 as UChar])
PUSHW_EBP_VAL       := static const BinarySeq new(3, [0x66 as UChar, 0xff, 0x75])
PUSHDW_EBP_VAL      := static const BinarySeq new(2, [0xff as UChar, 0x75])
MOV_EBP_ESP			:= static const BinarySeq new(2, [0x89 as UChar, 0xe5])
MOV_EBX_ADDRESS		:= static const BinarySeq new(1, [0xbb as UChar])
MOV_EBX_EBP_PLUS_8 	:= static const BinarySeq new(3, [0x8b as UChar, 0x5d, 0x08])
PUSH_EBX			:= static const BinarySeq new(1, [0x53 as UChar])
PUSH_ADDRESS		:= static const BinarySeq new(1, [0x68 as UChar])
CALL_ADDRESS		:= static const BinarySeq new(1, [0xe8 as UChar])
CALL_EBX			:= static const BinarySeq new(2, [0xff as UChar, 0xd3])
LEAVE				:= static const BinarySeq new(1, [0xc9 as UChar])
RET					:= static const BinarySeq new(1, [0xc3 as UChar])

pushClosure: static func <T> (bseq: BinarySeq, arg: T) -> BinarySeq {
	size := T size
	if(size == 1) {
		bseq append(PUSH_BYTE)
	} else if(size == 2) {
		bseq append(PUSH_WORD)
	} else if(size == 4) {
		bseq append(PUSH_DWORD)
	} else {
		fprintf(stderr, "Trying to push unknown size: %d\n", T size)
		x := 0
		x = 10 / x // dirty way of throwing an exception
	}
	bseq append(arg&, size)
}

pushCallerArg: static func <T> (bseq: BinarySeq, arg: T) -> BinarySeq {
    size := T size
    if (size == 1 || size == 2) {
        bseq += OpCodes PUSHW_EBP_VAL
    } else if (size == 4) {
        bseq += OpCodes PUSHDW_EBP_VAL
    }
    return bseq

}
