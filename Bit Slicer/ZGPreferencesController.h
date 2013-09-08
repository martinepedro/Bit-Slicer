/*
 * Created by Mayur Pawashe on 3/11/10.
 *
 * Copyright (c) 2012 zgcoder
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

// INVALID_KEY_CODE used to be -999, take in account
#define INVALID_KEY_CODE -1
#define ZG_HOT_KEY_MODIFIER @"ZG_HOT_KEY_MODIFIER"
#define ZG_HOT_KEY @"ZG_HOT_KEY_CODE"
#define ZG_CHECK_FOR_UPDATES @"SUEnableAutomaticChecks"
#define ZG_CHECK_FOR_ALPHA_UPDATES @"ZG_CHECK_FOR_ALPHA_UPDATES_2"
#define ZG_EXPAND_DOCUMENT_OPTIONS @"ZG_EXPAND_OPTIONS"
#define ZG_REGISTER_TYPES @"ZG_REGISTER_TYPES"
#define ZG_DEBUG_QUALIFIER @"ZG_DEBUG_QUALIFIER"
#define ZG_SHOWED_ATOS_WARNING @"ZG_SHOWED_ATOS_WARNING"

@interface ZGPreferencesController : NSWindowController

@end