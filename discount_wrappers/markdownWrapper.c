//#include "markdownWrapper.h"

#include <stdio.h>
#include "markdown.h"

int mkd_compile_wrapper(Document *doc, int flags) {
    return mkd_compile(doc, flags);
}

int mkd_document_wrapper(Document *p, char **res) {
    return mkd_document(p, res);
}

