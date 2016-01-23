import os.path
from libpuzzle import Puzzle, Signature, CompressedSignature, SIMILARITY_HIGH_THRESHOLD

here = os.path.dirname(os.path.abspath(__file__))

def test_puzzle():
    puzzle = Puzzle()
    del puzzle

def test_max_width():
    puzzle = Puzzle()
    assert puzzle.max_width == 3000
    puzzle.max_width = 42
    assert puzzle.max_width == 42

def test_max_height():
    puzzle = Puzzle()
    assert puzzle.max_height == 3000
    puzzle.max_height = 42
    assert puzzle.max_height == 42

def test_lambdas():
    puzzle = Puzzle()
    assert puzzle.lambdas == 9
    puzzle.lambdas = 42
    assert puzzle.lambdas == 42

def test_noise_cutoff():
    puzzle = Puzzle()
    assert puzzle.noise_cutoff == 2.0
    puzzle.noise_cutoff = 42.0
    assert puzzle.noise_cutoff == 42.0

def test_p_ratio():
    puzzle = Puzzle()
    assert puzzle.p_ratio == 2.0
    puzzle.p_ratio = 42.0
    assert puzzle.p_ratio == 42.0

def test_contrast_barrier_for_cropping():
    puzzle = Puzzle()
    assert puzzle.contrast_barrier_for_cropping == 0.05
    puzzle.contrast_barrier_for_cropping = 42.0
    assert puzzle.contrast_barrier_for_cropping == 42.0

def test_max_cropping_ratio():
    puzzle = Puzzle()
    assert puzzle.max_cropping_ratio == 0.25
    puzzle.max_cropping_ratio = 42.0
    assert puzzle.max_cropping_ratio == 42.0

def test_autocrop():
    puzzle = Puzzle()
    assert puzzle.autocrop is True
    puzzle.autocrop = False
    assert puzzle.autocrop is False

def test_cvec_from_file():
    puzzle = Puzzle()
    sign1 = puzzle.fill_cvec_from_file(os.path.join(here, 'img1.jpg'))
    assert isinstance(sign1, Signature)
    assert isinstance(sign1, bytes)

    comp1 = puzzle.compress_cvec(sign1)
    assert isinstance(comp1, CompressedSignature)
    assert isinstance(comp1, bytes)

    sign2 = puzzle.uncompress_cvec(comp1)
    assert isinstance(sign2, Signature)
    assert isinstance(sign2, bytes)

    assert sign1 == sign2

def test_distance():
    puzzle = Puzzle()
    sign1 = puzzle.fill_cvec_from_file(os.path.join(here, 'img1.jpg'))
    sign2 = puzzle.fill_cvec_from_file(os.path.join(here, 'img2.jpg'))
    sign3 = puzzle.fill_cvec_from_file(os.path.join(here, 'img3.jpg'))
    sign4 = puzzle.fill_cvec_from_file(os.path.join(here, 'img4.jpg'))

    distance = puzzle.vector_normalized_distance(sign1, sign1)
    assert distance == 0.0
    assert SIMILARITY_HIGH_THRESHOLD >= distance

    distance = puzzle.vector_normalized_distance(sign1, sign2)
    assert distance == 0.668185800663117
    assert SIMILARITY_HIGH_THRESHOLD >= distance

    distance = puzzle.vector_normalized_distance(sign1, sign3)
    assert distance == 0.8030216737090623
    assert SIMILARITY_HIGH_THRESHOLD < distance

    distance = puzzle.vector_normalized_distance(sign2, sign3)
    assert distance == 0.6249753932903005
    assert SIMILARITY_HIGH_THRESHOLD >= distance

    distance = puzzle.vector_normalized_distance(sign1, sign4)
    assert distance == 0.7411632893603013
    assert SIMILARITY_HIGH_THRESHOLD < distance
