import BinarySeq

OpCodes: class {

PUSH_EBP 			:= static const new BinarySeq(1, [0x55 as UChar])
PUSH_BYTE           := static const new BinarySeq(1, [0x6a as UChar])
PUSH_WORD           := static const new BinarySeq(1, [0x66 as UChar])
PUSH_DWORD          := static const new BinarySeq(1, [0x68 as UChar])
MOV_EBP_ESP			:= static const new BinarySeq(2, [0x89 as UChar, 0xe5])
MOV_EBX_ADDRESS		:= static const new BinarySeq(1, [0xbb as UChar])
MOV_EBX_EBP_PLUS_8 	:= static const new BinarySeq(3, [0x8b as UChar, 0x5d, 0x08])
PUSH_EBX			:= static const new BinarySeq(1, [0x53 as UChar])
PUSH_ADDRESS		:= static const new BinarySeq(1, [0x68 as UChar])
CALL_ADDRESS		:= static const new BinarySeq(1, [0xe8 as UChar])
CALL_EBX			:= static const new BinarySeq(2, [0xff as UChar, 0xd3])
LEAVE				:= static const new BinarySeq(1, [0xc9 as UChar])
RET					:= static const new BinarySeq(1, [0xc3 as UChar])
TEST                := static const new BinarySeq(1, [0x12 as UChar])

push: static func <T> (bseq: BinarySeq, arg: T) -> BinarySeq {
	size := T size
	if(size == 1) {
		bseq += PUSH_BYTE
	} else if(size == 2) {
		bseq += PUSH_WORD
	} else if(size == 4) {
		bseq += PUSH_DWORD
	} else {
		fprintf(stderr, "Trying to push unknown size: %d\n", T size)
		x := 0
		x = 10 / x // dirty way of throwing an exception
	}
	bseq += arg
}

}
