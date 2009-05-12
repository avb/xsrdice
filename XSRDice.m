//
//  XSRDice.m
//  XSRDice
//
//  Created by Adam Brown on 11/20/07.
//
//
//  Copyright © 2008 Adam Brown (Dicebag Games). All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//  
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY DICEBAG GAMES ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE SHIIRA PROJECT OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
//  THE POSSIBILITY OF SUCH DAMAGE.
//  
//

#define DSFMT_MEXP 216091

#import "XSRDice.h"
#import "mt19937ar.h"

@implementation XSRDice

- (id) init 
{
    if (self = [super init])
    {
        init_genrand(time(0));
        diceRolls = [[NSMutableArray alloc] init];
        
    }
    return self;
}

@synthesize dieRoll;
@synthesize dicePool;
@synthesize hits;
@synthesize diceRolls;
@synthesize glitchCounter;
@synthesize defaultTest;

- (int) dieRoll 
{
    int roll = (genrand_int32() % 6) + 1;
    return roll;
}

- (void) rollDice
{
    NSString *rollList;
    rollList = [[NSString alloc] initWithString:@"Dice Rolls: "];

    diceRolls.removeAllObjects;
    hits = 0;
    glitchCounter = 0;
    
    int tabIndex = [tabView indexOfTabViewItem:[tabView selectedTabViewItem]];

    if (dicePool > 0) {
		
        int i;
		for (i = 0; i < dicePool; i++)
		{
			NSInteger roll;
			roll = (genrand_int32() % 6) + 1;
			
			if (roll >= 5) {
				hits++;
				if (roll == 6 && (advancedEdgePool.intValue && defaultTest != @"Longshot Test\n" && tabIndex == 1) || (tabIndex == 0 && basicRuleOfSix == 1)) {
					dicePool++;
				}
			}
			
			if (roll == 1) {
				glitchCounter++;
			}
			
			[diceRolls insertObject:[NSNumber numberWithInt:roll] atIndex:i];
		}
		
		[diceRolls sortUsingSelector:@selector(compare:)];
		
        
        NSInteger glitchcheck = 0;
		glitchcheck = ((dicePool/2) + (dicePool%2));
		
         NSString *glitch;       // Set Glitch Output
		if (glitchCounter >= glitchcheck) {
			if (hits > 0){
				glitch = [[NSString alloc] initWithString:@"Glitch\n"];
			} else if (self.hits == 0){
				glitch = [[NSString alloc] initWithString:@"Critical Glitch\n"];
			}
		} else {
			glitch = [[NSString alloc] initWithString:@" "];
		}
		
        NSString *rollToPrint;      // Set Roll Output
		for (i = dicePool-1; i >= 0; i--) {
			rollToPrint = [diceRolls objectAtIndex:i];
			rollList = [rollList stringByAppendingFormat:@"%@ ", rollToPrint];
		}
		
        NSString *outputString;
        outputString = [[NSString alloc] init];
        
        if (defaultTest)
        {
            outputString = [[NSString alloc] initWithFormat:@"%@Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", defaultTest, dicePool, rollList, hits, glitch];
        } else {
            outputString = [[NSString alloc] initWithFormat:@"Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", dicePool, rollList, hits, glitch];
        }

		[[outputTextView textStorage] replaceCharactersInRange:NSMakeRange(0, 0)
                                                      withString:outputString];
		
	} else {
		NSBeep();
	}
}

- (IBAction)rollBasic:(id)sender
{
    dicePool = basicDicePool.intValue;
    self.rollDice;
}

- (IBAction)rollAdvanced:(id)sender
{
    
	if (!advancedSkillPool.intValue && advancedAttributePool.intValue >= 1) 
	{
		dicePool = advancedAttributePool.intValue + advancedEdgePool.intValue + advancedModifierPool.intValue - 1;
		defaultTest = [[NSString alloc] initWithString:@"Default Test\n"];
	} else {
		dicePool = advancedAttributePool.intValue + advancedSkillPool.intValue + advancedEdgePool.intValue;
		if (dicePool == advancedEdgePool.intValue) {
            dicePool = dicePool + advancedModifierPool.intValue;
			defaultTest = [[NSString alloc] initWithString:@"Longshot Test\n"];
		} else {
            dicePool = dicePool + advancedModifierPool.intValue;
            defaultTest = [[NSString alloc] initWithString:@""];
        }
	}
    
    self.rollDice;
}
	

- (IBAction)basicRuleOfSix:(id)sender
{
    if ([sender state]) {
        basicRuleOfSix = 1;
    } else {
        basicRuleOfSix = 0;
    }
}


@end
