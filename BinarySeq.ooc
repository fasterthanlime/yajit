import os/mmap
import structs/HashMap
include errno

errno: extern Int
strerror: extern func (Int) -> String

BinarySeq: class {
    
    data : UChar*
    size : SizeT
    index := 0
    transTable := HashMap<Int> new()
    
    init: func ~withData (=size, .data) {
        this(size)
        transTable["c"] = Char size
        transTable["h"] = Short size
        transTable["i"] = Int size
        transTable["l"] = Long size
        transTable["P"] = Pointer size

        index = size
        memcpy(this data, data, size * sizeof(UChar))
    }
    
    init: func ~withSize (=size) {
        memsize := size * sizeof(UChar)
        // at least 4096, and a multiple of 4096 that is bigger than memsize
        realsize := memsize + 4096 - (memsize % 4096)
        data = gc_malloc(realsize)
        result := mprotect(data, realsize, PROT_READ | PROT_WRITE | PROT_EXEC)
        if(result != 0) {
            printf("mprotect(%p, %d) failed with code %d. Message = %s\n", data, realsize, result, strerror(errno))
        }
        // mmap is leaking (cause we don't know when to free), and apparently not needed, but just in case, here's the correct call
        //data = mmap(null, memsize, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_LOCKED | MAP_ANONYMOUS, -1, 0)
    }
    
    append: func ~other (other: This) -> This {
        append(other data, other size)
    }
    
    append: func ~withLength (ptr: Pointer, ptrLength: SizeT) -> This {
        memcpy(data + index, ptr, ptrLength)
        index += ptrLength
        return this
    }
    
    reset: func { index = 0 }
    
    print: func {
        for(i : Int in 0..index)
            printf("%.2x ", data[i])
        println()    
    }
    
}

operator += (b1, b2 : BinarySeq) -> BinarySeq {
    b1 append(b2)
}

operator += <T> (b1 : BinarySeq, addon: T) -> BinarySeq {
    b1 append(addon&, T size)
}
