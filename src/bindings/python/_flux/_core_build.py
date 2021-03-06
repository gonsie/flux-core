from cffi import FFI

ffi = FFI()


ffi.set_source(
    "_flux._core",
    """
#include <src/include/flux/core.h>
#include <src/common/libdebugged/debugged.h>


void * unpack_long(ptrdiff_t num){
  return (void*)num;
}
// TODO: remove this when we can use cffi 1.10
#ifdef __GNUC__
#pragma GCC visibility push(default)
#endif
            """,
    libraries=["flux-core"],
)

cdefs = """
typedef int... ptrdiff_t;
typedef int... pid_t;
typedef ... va_list;
void * unpack_long(ptrdiff_t num);
void free(void *ptr);

    """

with open("_core_preproc.h") as h:
    cdefs = cdefs + h.read()

ffi.cdef(cdefs)
if __name__ == "__main__":
    ffi.emit_c_code("_core.c")
