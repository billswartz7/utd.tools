
#ifndef COMETCONFIG_H
#define COMETCONFIG_H

/* So we only include things once */

#include <utdconfig.h>
/* Now undef the things that we could override such as PACKAGE, etc. */
#include <utd/conf_undef.h>
#include <config.h>

#ifdef UTDTOOLS_GRAPHICS
#define UTD_G(x_xz)	x_xz
#else  /* ! UTDTOOLS_GRAPHICS */
#define UTD_G(x_xz)	
#endif /* UTDTOOLS_GRAPHICS */

#endif /* COMETCONFIG_H */
