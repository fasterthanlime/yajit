import BinarySeq
import x86-32/OpCodes
import os/mmap
import structs/[ArrayList,HashMap]
include errno


Cell: class <T>{
    val :T
    init: func(=val) {}
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

Partial: abstract class {
    genCode: abstract func<T>(funcArg: Pointer, arg: T, sizes: String) -> Pointer
    genCode: abstract func ~multipleArgs(funcArg: Pointer, arg: ArrayList<Cell<Pointer>>, sizes: String) -> Pointer
}    
    
