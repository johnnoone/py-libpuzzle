## cython: linetrace=True
## distutils: define_macros=CYTHON_TRACE=1
# distutils: libraries = puzzle gd
# distutils: include_dirs = /usr/include

cdef extern from "puzzle.h":


    cdef double PUZZLE_CVEC_SIMILARITY_THRESHOLD
    cdef double PUZZLE_CVEC_SIMILARITY_HIGH_THRESHOLD
    cdef double PUZZLE_CVEC_SIMILARITY_LOW_THRESHOLD
    cdef double PUZZLE_CVEC_SIMILARITY_LOWER_THRESHOLD

    ctypedef struct PuzzleContext:
        unsigned int puzzle_max_width
        unsigned int puzzle_max_height
        unsigned int puzzle_lambdas
        double puzzle_p_ratio
        double puzzle_noise_cutoff
        double puzzle_contrast_barrier_for_cropping
        double puzzle_max_cropping_ratio
        int puzzle_enable_autocrop
        unsigned long magic

    ctypedef struct PuzzleCvec:
        size_t sizeof_vec
        signed char *vec

    ctypedef struct PuzzleCompressedCvec:
        size_t sizeof_compressed_vec
        unsigned char *vec

    ctypedef struct PuzzleDvec:
        size_t sizeof_vec
        size_t sizeof_compressed_vec
        double *vec

    void puzzle_init_context(PuzzleContext * const context)
    void puzzle_free_context(PuzzleContext * const context)
    int puzzle_set_max_width(PuzzleContext * const context, const unsigned int width)
    int puzzle_set_max_height(PuzzleContext * const context, const unsigned int height)
    int puzzle_set_lambdas(PuzzleContext * const context, const unsigned int lambdas)
    int puzzle_set_noise_cutoff(PuzzleContext * const context, const double noise_cutoff)
    int puzzle_set_p_ratio(PuzzleContext * const context, const double p_ratio)
    int puzzle_set_contrast_barrier_for_cropping(PuzzleContext * const context, const double barrier)
    int puzzle_set_max_cropping_ratio(PuzzleContext * const context, const double ratio)
    int puzzle_set_autocrop(PuzzleContext * const context, const bint enable);

    void puzzle_init_cvec(PuzzleContext * const context, PuzzleCvec * const cvec)
    void puzzle_init_dvec(PuzzleContext * const context, PuzzleDvec * const dvec)
    int puzzle_fill_cvec_from_file(PuzzleContext * const context, PuzzleCvec * const cvec, const char * const file)
    void puzzle_free_cvec(PuzzleContext * const context, PuzzleCvec * const cvec)
    void puzzle_init_compressed_cvec(PuzzleContext * const context, PuzzleCompressedCvec * const compressed_cvec)
    void puzzle_free_compressed_cvec(PuzzleContext * const context, PuzzleCompressedCvec * const compressed_cvec)
    int puzzle_compress_cvec(PuzzleContext * const context, PuzzleCompressedCvec * const compressed_cvec, const PuzzleCvec * const cvec)
    int puzzle_uncompress_cvec(PuzzleContext * const context, const PuzzleCompressedCvec * const compressed_cvec, PuzzleCvec * const cvec)
    double puzzle_vector_normalized_distance(PuzzleContext * const context, const PuzzleCvec * const cvec1, const PuzzleCvec * const cvec2, const int fix_for_texts)

SIMILARITY_THRESHOLD = PUZZLE_CVEC_SIMILARITY_THRESHOLD
SIMILARITY_HIGH_THRESHOLD = PUZZLE_CVEC_SIMILARITY_HIGH_THRESHOLD
SIMILARITY_LOW_THRESHOLD = PUZZLE_CVEC_SIMILARITY_LOW_THRESHOLD
SIMILARITY_LOWER_THRESHOLD = PUZZLE_CVEC_SIMILARITY_LOWER_THRESHOLD


class PuzzleError(RuntimeError):
    pass


cdef class Puzzle:

    cdef PuzzleContext context

    def __cinit__(self):
        puzzle_init_context(&self.context)

    def __dealloc__(self):
        puzzle_free_context(&self.context)

    property max_width:

        def __get__(self):
            return self.context.puzzle_max_width

        def __set__(self, unsigned int value):
            response = puzzle_set_max_width(&self.context, value)
            if response:
                raise AttributeError('unable to set max width')

    property max_height:

        def __get__(self):
            return self.context.puzzle_max_height

        def __set__(self, unsigned int value):
            response = puzzle_set_max_height(&self.context, value)
            if response:
                raise AttributeError('unable to set max height')

    property lambdas:

        def __get__(self):
            return self.context.puzzle_lambdas

        def __set__(self, unsigned int value):
            response = puzzle_set_lambdas(&self.context, value)
            if response:
                raise AttributeError('unable to set lambdas')

    property noise_cutoff:

        def __get__(self):
            return self.context.puzzle_noise_cutoff

        def __set__(self, double value):
            response = puzzle_set_noise_cutoff(&self.context, value)
            if response:
                raise AttributeError('unable to set noise cutoff')

    property p_ratio:

        def __get__(self):
            return self.context.puzzle_p_ratio

        def __set__(self, double value):
            response = puzzle_set_p_ratio(&self.context, value)
            if response:
                raise AttributeError('unable to set p_ratio')

    property contrast_barrier_for_cropping:

        def __get__(self):
            return self.context.puzzle_contrast_barrier_for_cropping

        def __set__(self, double value):
            response = puzzle_set_contrast_barrier_for_cropping(&self.context, value)
            if response:
                raise AttributeError('unable to set p_ratio')

    property max_cropping_ratio:

        def __get__(self):
            return self.context.puzzle_max_cropping_ratio

        def __set__(self, double value):
            response = puzzle_set_max_cropping_ratio(&self.context, value)
            if response:
                raise AttributeError('unable to set p_ratio')

    property autocrop:

        def __get__(self):
            return <bint>self.context.puzzle_enable_autocrop

        def __set__(self, bint value):
            response = puzzle_set_autocrop(&self.context, value)
            if response:
                raise AttributeError('unable to set p_ratio')

    cpdef fill_cvec_from_file(self, char* filename):
        cdef PuzzleCvec cvec

        puzzle_init_cvec(&self.context, &cvec)
        if puzzle_fill_cvec_from_file(&self.context, &cvec, filename):
            puzzle_free_cvec(&self.context, &cvec);
            raise PuzzleError('Unable to fill cvec from file')

        cdef Py_ssize_t length = 0
        length = cvec.sizeof_vec

        response = cvec.vec[:length]
        puzzle_free_cvec(&self.context, &cvec);
        return response

    cpdef compress_cvec(self, sign):
        cdef PuzzleCompressedCvec compressed_cvec
        cdef PuzzleCvec cvec

        puzzle_init_compressed_cvec(&self.context, &compressed_cvec)
        puzzle_init_cvec(&self.context, &cvec)

        cvec.vec = sign
        cvec.sizeof_vec = <size_t>len(sign)

        if puzzle_compress_cvec(&self.context, &compressed_cvec, &cvec):
            puzzle_free_compressed_cvec(&self.context, &compressed_cvec)
            cvec.vec = NULL
            puzzle_free_cvec(&self.context, &cvec)
            raise PuzzleError('Unable to compress cvec')

        cdef Py_ssize_t length = 0
        length = compressed_cvec.sizeof_compressed_vec

        response =compressed_cvec.vec[:length]

        puzzle_free_compressed_cvec(&self.context, &compressed_cvec)
        cvec.vec = NULL
        puzzle_free_cvec(&self.context, &cvec)
        return response

    cpdef uncompress_cvec(self, sign):
        cdef PuzzleCompressedCvec compressed_cvec
        cdef PuzzleCvec cvec

        puzzle_init_compressed_cvec(&self.context, &compressed_cvec)
        puzzle_init_cvec(&self.context, &cvec)

        compressed_cvec.vec = sign
        compressed_cvec.sizeof_compressed_vec = <size_t>len(sign)

        if puzzle_uncompress_cvec(&self.context, &compressed_cvec, &cvec):
            puzzle_free_cvec(&self.context, &cvec)
            compressed_cvec.vec = NULL
            puzzle_free_compressed_cvec(&self.context, &compressed_cvec)
            raise PuzzleError('Unable to uncompress cvec')

        cdef Py_ssize_t length = 0
        length = cvec.sizeof_vec

        response = cvec.vec[:length]
        puzzle_free_cvec(&self.context, &cvec)
        compressed_cvec.vec = NULL
        puzzle_free_compressed_cvec(&self.context, &compressed_cvec)
        return response

    cpdef vector_normalized_distance(self, sign1, sign2):
        """Computes the distance between two vectors.

        Result is between 0.0 and 1.0
        """
        cdef PuzzleCvec cvec1, cvec2
        cdef double distance

        puzzle_init_cvec(&self.context, &cvec1)
        puzzle_init_cvec(&self.context, &cvec2)

        cvec1.vec = sign1
        cvec1.sizeof_vec = <size_t>len(sign1)

        cvec2.vec = sign2
        cvec2.sizeof_vec = <size_t>len(sign2)

        distance = puzzle_vector_normalized_distance(&self.context,
                                                     &cvec1,
                                                     &cvec2,
                                                     0)
        cvec1.vec = NULL
        cvec2.vec = NULL
        puzzle_free_cvec(&self.context, &cvec1);
        puzzle_free_cvec(&self.context, &cvec2);
        return distance
