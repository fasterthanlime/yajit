BinarySeq: class {
	
	data : UChar*
	size : SizeT
	index := 0
	
	new: func ~withData (=size, .data) {
		this(size)
		index = size
		memcpy(this data, data, size * sizeof(Octet))
		printf("Created new BinarySeq of size %d: ", size)
		print()
	}
	
	new: func ~withSize (=size) {
		printf("Created new empty BinarySeq of size %d\n", size)
		data = gc_malloc(size * sizeof(Octet))
	}
	
	new: func ~fromAddress (ptr: Pointer) {
		this ~withSize (sizeof(Pointer))
		memcpy(data, ptr&, sizeof(Pointer))
		printf("sizeof(Char) = %d, sizeof(UChar) = %d\n", sizeof(Char), sizeof(UChar))
		printf("Created new BinarySeq of size %d from address %p and data %p: ", size, ptr, (data as Pointer*)[0])
		print()
	}
	
	append: func (other: This) -> This {
		memcpy(data + index, other data, other size)
		index += other size
		return this
	}
	
	reset: func index = 0
	
	print: func {
		printf("BinarySeq data (size=%d)\t", size)
		for(i : Int in 0..index)
			printf("%.2x ", data[i])
		println()
	}
	
}

operator += (b1, b2 : BinarySeq) -> BinarySeq {
	b1 append(b2)
}
