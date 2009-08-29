BinarySeq: class {
	
	data : UChar*
	size : SizeT
	index := 0
	
	new: func ~withData (=size, .data) {
		this(size)
		index = size
		memcpy(this data, data, size * sizeof(UChar))
	}
	
	new: func ~withSize (=size) {
		data = gc_malloc(size * sizeof(UChar))
	}
	
	append: func ~other (other: This) -> This {
		append(other data, other size)
	}
	
	append: func ~withLength (ptr: Pointer, ptrLength: SizeT) -> This {
		memcpy(data + index, ptr, ptrLength)
		index += ptrLength
		return this
	}
	
	reset: func index = 0
	
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
