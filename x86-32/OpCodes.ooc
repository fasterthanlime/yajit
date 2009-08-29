import BinarySeq

OpCodes: class {

PUSH_EBP 			:= static const new BinarySeq(1, [0x55 as Octet])
MOV_EBP_ESP			:= static const new BinarySeq(2, [0x89 as Octet, 0xe5])
MOV_EBX_EBP_PLUS_8 	:= static const new BinarySeq(3, [0x8b as Octet, 0x5d, 0x08])
PUSH_EBX			:= static const new BinarySeq(1, [0x53 as Octet])
PUSH_ADDRESS		:= static const new BinarySeq(1, [0x68 as Octet])
CALL_ADDRESS		:= static const new BinarySeq(1, [0xe8 as Octet])
CALL_EBX			:= static const new BinarySeq(1, [0xff as Octet, 0xd3])
LEAVE				:= static const new BinarySeq(1, [0xc9 as Octet])
RET					:= static const new BinarySeq(1, [0xc3 as Octet])

}
