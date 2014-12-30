/*
 * Created by Mayur Pawashe on 12/27/14.
 *
 * Copyright (c) 2014 zgcoder
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

#import "ZGLocalProcessList.h"
#import "ZGRunningProcess.h"
#import "ZGRunningProcessObserver.h"
#import "ZGVirtualMemory.h"

#import <sys/types.h>
#import <sys/sysctl.h>

@interface ZGProcessList ()

- (void)updateRunningProcessList:(NSArray *)newRunningProcesses;

@end

@implementation ZGLocalProcessList

// http://stackoverflow.com/questions/7729245/can-i-use-sysctl-to-retrieve-a-process-list-with-the-user
// http://www.nightproductions.net/dsprocessesinfo_m.html
// Apparently I could use proc_listpids instead of sysctl.. Although we are already using sysctl for obtaining CPU architecture, and I'm unsure if this would actually be a better choice
- (void)retrieveList
{
	struct kinfo_proc *processList = NULL;
	size_t length = 0;
	
	static const int name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
	
	// Call sysctl with a NULL buffer to get proper length
	if (sysctl((int *)name, (sizeof(name) / sizeof(*name)) - 1, NULL, &length, NULL, 0) != 0) return;
	
	// Allocate buffer
	processList = malloc(length);
	if (!processList) return;
	
	// Get the actual process list
	if (sysctl((int *)name, (sizeof(name) / sizeof(*name)) - 1, processList, &length, NULL, 0) != 0)
	{
		free(processList);
		return;
	}
	
	NSMutableArray *newRunningProcesses = [[NSMutableArray alloc] init];
	
	int processCount = (int)(length / sizeof(struct kinfo_proc));
	for (int processIndex = 0; processIndex < processCount; processIndex++)
	{
		uid_t uid = processList[processIndex].kp_eproc.e_ucred.cr_uid;
		pid_t processID = processList[processIndex].kp_proc.p_pid;
		
		// I want user processes and I don't want zombies!
		// Also don't get a process if it's still being created by fork() or if the pid is -1
		if (processID != -1 && uid == getuid() && !(processList[processIndex].kp_proc.p_stat & SIDL))
		{
			// Get CPU type
			// http://stackoverflow.com/questions/1350181/determine-a-processs-architecture
			
			size_t mibLen = CTL_MAXNAME;
			int mib[CTL_MAXNAME];
			
			if (sysctlnametomib("sysctl.proc_cputype", mib, &mibLen) == 0)
			{
				mib[mibLen] = processID;
				mibLen++;
				
				cpu_type_t cpuType;
				size_t cpuTypeSize;
				cpuTypeSize = sizeof(cpuType);
				
				if (sysctl(mib, (u_int)mibLen, &cpuType, &cpuTypeSize, 0, 0) == 0)
				{
					ZGRunningProcess *runningProcess = [[ZGRunningProcess alloc] initWithProcessIdentifier:processID is64Bit:((cpuType & CPU_ARCH_ABI64) != 0) internalName:@(processList[processIndex].kp_proc.p_comm)];
					[newRunningProcesses addObject:runningProcess];
				}
			}
		}
	}
	
	[self updateRunningProcessList:newRunningProcesses];
	
	free(processList);
}

@end