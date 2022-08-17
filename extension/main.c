// SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
//
// SPDX-License-Identifier: MIT
 
#include "toyboxes.h"

#include "pd_api.h"

int eventHandler(PlaydateAPI* playdate, PDSystemEvent event, uint32_t arg)
{
    if(event == kEventInitLua) {
        REGISTER_TOYBOXES(playdate)
    }
    
    return 0;
}
