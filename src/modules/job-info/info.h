/************************************************************\
 * Copyright 2018 Lawrence Livermore National Security, LLC
 * (c.f. AUTHORS, NOTICE.LLNS, COPYING)
 *
 * This file is part of the Flux resource manager framework.
 * For details, see https://github.com/flux-framework.
 *
 * SPDX-License-Identifier: LGPL-3.0
\************************************************************/

#ifndef _FLUX_JOB_INFO_INFO_H
#define _FLUX_JOB_INFO_INFO_H

#include <flux/core.h>
#include <czmq.h>

#include "job_state.h"

struct info_ctx {
    flux_t *h;
    flux_msg_handler_t **handlers;
    zlist_t *lookups;
    zlist_t *watchers;
    zlist_t *guest_watchers;
    struct job_state_ctx *jsctx;
    zlistx_t *idsync_lookups;
    zhashx_t *idsync_waits;
};

#endif /* _FLUX_JOB_INFO_INFO_H */

/*
 * vi:tabstop=4 shiftwidth=4 expandtab
 */

