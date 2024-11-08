
#ifndef COMETCONFIG_H
#define COMETCONFIG_H

/* So we only include things once */

#include <utdconfig.h>
/* Now undef the things that we could override such as PACKAGE, etc. */
#include <utd/conf_undef.h>
#include <config.h>

#ifdef UTDGUI_GRAPHICS
#define UTD_G(x_xz)	x_xz
#else  /* ! UTDGUI_GRAPHICS */
#define UTD_G(x_xz)	
#endif /* UTDGUI_GRAPHICS */

#endif /* COMETCONFIG_H */
