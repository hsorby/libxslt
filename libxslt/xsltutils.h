/*
 * xsltutils.h: interfaces for the utilities module of the XSLT engine
 *
 * See Copyright for the status of this software.
 *
 * Daniel.Veillard@w3.org
 */

#ifndef __XML_XSLTUTILS_H__
#define __XML_XSLTUTILS_H__

#include <libxml/xpath.h>
#include <libxml/xmlerror.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * To cleanup
 */
xmlChar *xmlSplitQName2(const xmlChar *name, xmlChar **prefix);
void xmlXPathBooleanFunction(xmlXPathParserContextPtr ctxt, int nargs);

/*
 * Useful macros
 */

#define TODO 								\
    xsltGenericError(xsltGenericErrorContext,				\
	    "Unimplemented block at %s:%d\n",				\
            __FILE__, __LINE__);

#define STRANGE 							\
    xsltGenericError(xsltGenericErrorContext,				\
	    "Internal error at %s:%d\n",				\
            __FILE__, __LINE__);

#define IS_XSLT_ELEM(n)							\
    (((n) != NULL) && ((n)->ns != NULL) &&				\
     (xmlStrEqual((n)->ns->href, XSLT_NAMESPACE)))

#define IS_XSLT_NAME(n, val)						\
    (xmlStrEqual((n)->name, (const xmlChar *) (val)))


/*
 * XSLT specific error and debug reporting functions
 */
extern xmlGenericErrorFunc xsltGenericError;
extern void *xsltGenericErrorContext;
extern xmlGenericErrorFunc xsltGenericDebug;
extern void *xsltGenericDebugContext;

void		xsltSetGenericErrorFunc		(void *ctx,
						 xmlGenericErrorFunc handler);
void		xsltSetGenericDebugFunc		(void *ctx,
						 xmlGenericErrorFunc handler);

/*
 * Sorting ... this is definitely a temporary interface !
 */

void		xsltSortFunction		(xmlNodeSetPtr list,
						 xmlXPathObjectPtr *results,
						 int descending,
						 int number);
#ifdef __cplusplus
}
#endif

#endif /* __XML_XSLTUTILS_H__ */
