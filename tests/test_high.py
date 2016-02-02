import os.path
import pytest
from libpuzzle import Puzzle, Signature

here = os.path.dirname(os.path.abspath(__file__))


def test_puzzle():
    a = Puzzle(max_width=42)
    b = Puzzle(max_width=42)
    c = Puzzle(max_width=678)
    assert a == b
    assert a != c


def test_load_signature():
    puzzle = Puzzle()
    sign = puzzle.from_filename(os.path.join(here, 'img1.jpg'))
    a = sign.value
    b = sign.compressed

    s1 = puzzle.from_signature(a)
    assert sign == s1

    s2 = puzzle.from_compressed_signature(b)
    assert sign == s2


def test_compare_signature():
    a = Signature('foo', None, 'bar')
    assert isinstance(a, Signature)

    b = Signature('foo', None, 'bar')
    assert isinstance(b, Signature)

    assert a == b
    assert a != 'foo'
    assert a != 'bar'

    with pytest.raises(ValueError):
        Signature(None, None)
