use yajit
import structs/ArrayList
import yajit/Partial


test: func {
    "-- Yay =) This is the test function --" println()
}

test2: func (ptr: Pointer, arg: Int, secArg: Int, thirdArg: Short) -> String {
    printf("Address of param %p, number = %d, name = '%s'\n", ptr, ptr as TestStruct number, ptr as TestStruct name)
    printf("First non-closure arg: %d\n", arg)
    printf("Second arg: %d\n", secArg)
    printf("%d\n", thirdArg)
    return "Oh my god, even return values work!"
}

test3: func(i, j, k: Int) -> Int {
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    printf("k:%d\n", k)
    i+j
}

test4: func(i, j: Int) -> Int {
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    i+j
}

test5: func(i, j: Int, tStruct: TestStruct, k: Float) -> Int {
    printf("i:%d\n", i)
    printf("j:%d\n", j)
    printf("k:%f\n", k)
    printf("Address of param %p, number = %d, name = '%s'\n", tStruct, tStruct as TestStruct number, tStruct as TestStruct name)
    i+j+k
}

main: func {
    a := TestStruct new(42, "mwahhaha")
    "Generating code.." println()
    clArg1 := Cell<Int> new(21)
    clArg2 := Cell<Int> new(44)
    clArg3 := Cell<Pointer> new(a)
    closureArgs := ArrayList<Cell<Pointer>> new()
    closureArgs add(clArg1).add(clArg2).add(clArg3)
    partial := Partial new(test2)
    partial setNonPartialArgs("iii")
    function1 := partial genCode(a) as Func -> String    
    function1(2, 3, 4) println()
    partial = Partial new(test3)
    partial setNonPartialArgs("ii")
    function2 := partial genCode(4) as Func -> Int
    printf("%d\n", function2(2, 2))
    partial = Partial new(test4)
    function3 := partial genCode(closureArgs) as Func -> Int
    function3()
    partial = Partial new(test5)
    partial setNonPartialArgs("i")
    function4 := partial genCode(closureArgs) as Func -> Int
    function4 (partial converseFloat(23.3))
    "Finished!" println()
}

