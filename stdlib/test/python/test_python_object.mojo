# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #
# XFAIL: asan && !system-darwin
# RUN: %mojo -I %py_interop_bin_dir -I %test_py_interop_bin_dir %s | FileCheck %s

from memory.unsafe import Pointer
from python._cpython import CPython, PyObjectPtr
from python.object import PythonObject
from python.python import Python

from testing import assert_true, assert_false


# CHECK-LABEL: test_dunder_methods
fn test_dunder_methods(inout python: Python):
    print("=== test_dunder_methods ===")
    try:
        let a = PythonObject(34)
        let b = PythonObject(10)

        # __add__
        # CHECK-NEXT: 44
        var c = a + b
        print(c)

        # __add__
        # CHECK-NEXT: 134
        c = a + 100
        print(c)

        # __iadd__
        # CHECK-NEXT: 234
        c += 100
        print(c)

        # __radd__
        # CHECK-NEXT: 134
        c = 100 + a
        print(c)

        # __sub__
        # CHECK-NEXT: 24
        c = a - b
        print(c)

        # __isub__
        # CHECK-NEXT: -76
        c -= 100
        print(c)

        # __sub__
        # CHECK-NEXT: -66
        c = a - 100
        print(c)

        # __rsub__
        # CHECK-NEXT: 66
        c = 100 - a
        print(c)

        # __mul__
        # CHECK-NEXT: 340
        c = a * b
        print(c)

        # __imul__
        # CHECK-NEXT: 3400
        c *= 10
        print(c)

        # __mul__
        # CHECK-NEXT: 340
        c = a * 10
        print(c)

        # __rmul__
        # CHECK-NEXT: 340
        c = 34 * b
        print(c)

        # __floordiv__
        # CHECK-NEXT: 3
        c = a // b
        print(c)

        # __ifloordiv__
        # CHECK-NEXT: 1
        c //= 2
        print(c)

        # __floordiv__
        # CHECK-NEXT: 3
        c = a // 10
        print(c)

        # __rfloordiv__
        # CHECK-NEXT: 3
        c = 34 // b
        print(c)

        # __truediv__
        # CHECK-NEXT: 3.4
        c = a / b
        print(c)

        # __itruediv__
        # CHECK-NEXT: 1.7
        c /= 2
        print(c)

        # __truediv__
        # CHECK-NEXT: 3.4
        c = a / 10
        print(c)

        # __rtruediv__
        # CHECK-NEXT: 3.4
        c = 34 / b
        print(c)

        # __mod__
        # CHECK-NEXT: 4
        c = a % b
        print(c)

        # __imod__
        # CHECK-NEXT: 1
        c %= 3
        print(c)

        # __mod__
        # CHECK-NEXT: 4
        c = a % 10
        print(c)

        # __rmod__
        # CHECK-NEXT: 4
        c = 34 % b
        print(c)

        # __xor__
        # CHECK-NEXT: 40
        c = a ^ b
        print(c)

        # __ixor__
        # CHECK-NEXT: 39
        c ^= 15
        print(c)

        # __xor__
        # CHECK-NEXT: 40
        c = a ^ 10
        print(c)

        # __rxor__
        # CHECK-NEXT: 40
        c = 34 ^ b
        print(c)

        # __or__
        # CHECK-NEXT: 42
        c = a | b
        print(c)

        # __ior__
        # CHECK-NEXT: 43
        c |= 9
        print(c)

        # __or__
        # CHECK-NEXT: 42
        c = a | 10
        print(c)

        # __ror__
        # CHECK-NEXT: 42
        c = 34 | b
        print(c)

        # __and__
        # CHECK-NEXT: 2
        c = a & b
        print(c)

        # __iand__
        # CHECK-NEXT: 2
        c &= 6
        print(c)

        # __and__
        # CHECK-NEXT: 2
        c = a & 10
        print(c)

        # __rand__
        # CHECK-NEXT: 2
        c = 34 & b
        print(c)

        # __rshift__
        let d = PythonObject(2)
        # CHECK-NEXT: 8
        c = a >> d
        print(c)

        # __irshift__
        # CHECK-NEXT: 2
        c >>= 2
        print(c)

        # __rshift__
        # CHECK-NEXT: 8
        c = a >> 2
        print(c)

        # __rrshift__
        # CHECK-NEXT: 8
        c = 34 >> d
        print(c)

        # __lshift__
        # CHECK-NEXT: 136
        c = a << d
        print(c)

        # __ilshift__
        # CHECK-NEXT: 272
        c <<= 1
        print(c)

        # __lshift__
        # CHECK-NEXT: 136
        c = a << 2
        print(c)

        # __rlshift__
        # CHECK-NEXT: 136
        c = 34 << d
        print(c)

        # __pow__
        # CHECK-NEXT: 1156
        c = a**d
        print(c)

        # __ipow__
        # CHECK-NEXT: 81
        c = 3
        c **= 4
        print(c)

        # __pow__
        # CHECK-NEXT: 1156
        c = a**2
        print(c)

        # __rpow__
        # CHECK-NEXT: 1156
        c = 34**d
        print(c)

        # __lt__
        # CHECK-NEXT: False
        c = a < b
        print(c)

        # __le__
        # CHECK-NEXT: False
        c = a <= b
        print(c)

        # __gt__
        # CHECK-NEXT: True
        c = a > b
        print(c)

        # __ge__
        # CHECK-NEXT: True
        c = a >= b
        print(c)

        # __eq__
        # CHECK-NEXT: False
        c = a == b
        print(c)

        # __ne__
        # CHECK-NEXT: True
        c = a != b
        print(c)

        # __pos__
        # CHECK-NEXT: 34
        c = +a
        print(c)

        # __neg__
        # CHECK-NEXT: -34
        c = -a
        print(c)

        # __invert__
        # CHECK-NEXT: -35
        c = ~a
        print(c)
    except e:
        pass


def test_bool_conversion() -> None:
    let x: PythonObject = 1
    # CHECK: test_bool: True
    print("test_bool:", x == 0 or x == 1)


fn test_iter() raises -> None:
    var list: PythonObject = ["apple", "orange", "banana"]
    for fruit in list:
        print("I like to eat", fruit)

    var list2: PythonObject = []
    for fruit in list2:
        print("I have eaten", fruit)

    var not_iterable: PythonObject = 3
    for x in not_iterable:
        print("I should not exist", x)

    var mydict = Python.dict()
    mydict["vegetable"] = "carrot"
    mydict["dessert"] = "apple pie"
    mydict["protein"] = "chicken"
    for key in mydict:
        print(key)


fn test_string_conversions() -> None:
    fn test_string_literal() -> None:
        try:
            let mojo_str: StringLiteral = "mojo"
            let py_str = PythonObject(mojo_str)
            let py_capitalized = py_str.capitalize()
            var py = Python()
            let mojo_capitalized = py.__str__(py_capitalized)
            # CHECK: Mojo
            print(mojo_capitalized)
        except e:
            print("Error occurred")

    fn test_string_ref() -> None:
        try:
            let mojo_str: StringLiteral = "mojo"
            let mojo_strref = StringRef(mojo_str)
            let py_str = PythonObject(mojo_strref)
            let py_capitalized = py_str.capitalize()
            var py = Python()
            let mojo_capitalized = py.__str__(py_capitalized)
            # CHECK: Mojo
            print(mojo_capitalized)
        except e:
            print("Error occurred")

    fn test_string() -> None:
        try:
            let mo_str = String("mo")
            let jo_str = String("jo")
            let mojo_str = mo_str + jo_str
            let py_str = PythonObject(mojo_str)
            let py_capitalized = py_str.capitalize()
            var py = Python()
            let mojo_capitalized = py.__str__(py_capitalized)
            # CHECK: Mojo
            print(mojo_capitalized)
        except e:
            print("Error occurred")

    test_string_literal()
    test_string_ref()
    test_string()


def test_len():
    let empty_list = Python.evaluate("[]")
    # CHECK: 0
    print(len(empty_list))

    let l1 = Python.evaluate("[1,2,3]")
    # CHECK: 3
    print(len(l1))

    let l2 = Python.evaluate("[42,42.0]")
    # CHECK: 2
    print(len(l2))


def test_is():
    var x = PythonObject(500)
    var y = PythonObject(500)
    assert_false(x is y)
    assert_true(x is not y)

    # Assign to a new variable but this still holds
    # the same object and same memory location
    var z = x
    assert_true(z is x)
    assert_false(z is not x)

    # Two separate lists/objects, and therefore are not the "same".
    # as told by the `__is__` function. They point to different addresses.
    let l1 = Python.evaluate("[1,2,3]")
    let l2 = Python.evaluate("[1,2,3]")
    assert_false(l1 is l2)
    assert_true(l1 is not l2)


def main():
    # initializing Python instance calls init_python
    var python = Python()

    test_dunder_methods(python)
    test_bool_conversion()
    test_string_conversions()
    test_len()
    test_is()
    # CHECK: I like to eat apple
    # CHECK: I like to eat orange
    # CHECK: I like to eat banana
    # CHECK: vegetable
    # CHECK: dessert
    # CHECK: protein
    test_iter()
