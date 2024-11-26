#include "limits.h"
#include "stdio.h"
#include "stdlib.h"

/* returns negative value on error. This should be pure C compatible, so no fstat. */
static long lodepng_filesize(const char *filename) {
    FILE *file;
    long size;
    file = fopen(filename, "rb");
    if (!file) return -1;

    if (fseek(file, 0, SEEK_END) != 0) {
        fclose(file);
        return -1;
    }

    size = ftell(file);
    /* It may give LONG_MAX as directory size, this is invalid for us. */
    if (size == LONG_MAX) size = -1;

    fclose(file);
    return size;
}

/* load file into buffer that already has the correct allocated size. Returns error code.*/
static unsigned lodepng_buffer_file(unsigned char *out, size_t size, const char *filename) {
    FILE *file;
    size_t readsize;
    file = fopen(filename, "rb");
    if (!file) return 78;

    readsize = fread(out, 1, size, file);
    fclose(file);

    if (readsize != size) return 78;
    return 0;
}

unsigned load_file(unsigned char **out, size_t *outsize, const char *filename);
unsigned save_file(const unsigned char *buffer, size_t buffersize, const char *filename);

unsigned load_file(unsigned char **out, size_t *outsize, const char *filename) {
    long size = lodepng_filesize(filename);
    if (size < 0) return 78;
    *outsize = (size_t) size;

    *out = (unsigned char *) malloc((size_t) size);
    if (!(*out) && size > 0) return 83; /*the above malloc failed*/

    return lodepng_buffer_file(*out, (size_t) size, filename);
}

/*write given buffer to the file, overwriting the file, it doesn't append to it.*/
unsigned save_file(const unsigned char *buffer, size_t buffersize, const char *filename) {
    FILE *file;
    file = fopen(filename, "wb");
    if (!file) return 79;
    fwrite(buffer, 1, buffersize, file);
    fclose(file);
    return 0;
}