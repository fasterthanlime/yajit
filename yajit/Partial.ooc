import BinarySeq
import x86-32/OpCodes
import os/mmap
import structs/[ArrayList,HashMap]
include errno

Partial: abstract class {
    genCode: abstract func<T>(funcArg: Pointer, arg: T, sizes: String) -> Pointer
    genCode: abstract func ~multipleArgs(funcArg: Pointer, arg: ArrayList<Cell<Pointer>>, sizes: String) -> Pointer
}    
    
