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

#import "XSRDice.h"


@implementation XSRDice

- (IBAction)rollBasic:(id)sender
{
	NSInteger dicePool;
    NSInteger roll;
    NSInteger glitchcounter = 0;
	NSInteger hits = 0;    
    NSInteger i;
    
	NSMutableArray *diceRolls;
	NSString *rollList;
	
    
    dicePool = [basicDicePool intValue];
	diceRolls = [[NSMutableArray alloc] init];
	rollList = [[NSString alloc] initWithString:@"Dice Rolls: "];


	if (dicePool > 0) 
	{
		for (i = 0; i < dicePool; i++)      // Roll Dice
		{
			roll = (random() % 6) + 1;
			
			if (roll >= 5) {        // Hit Counter
				hits++;
				if (roll == 6 && basicRuleOfSix == 1) {
					dicePool++;
				}
			}
			
			if (roll == 1) {    // Glitch Counter
				glitchcounter++;
			}
			
			[diceRolls insertObject:[NSNumber numberWithInt:roll] atIndex:i];   // Insert roll into array
		}

		[diceRolls sortUsingSelector:@selector(compare:)];      // Order rolls High to Low
		
        NSInteger glitchcheck = 0;
		glitchcheck = ((dicePool/2) + (dicePool%2));
		
        NSString *glitch;       // Set Glitch Output
		if (glitchcounter >= glitchcheck) {
			if (hits > 0){
				glitch = [[NSString alloc] initWithString:@"Glitch\n"];
			} else if (hits == 0){
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
		
		NSString *outputString = [[NSString alloc] initWithFormat:@"Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", dicePool, rollList, hits, glitch];
		
		
		[[basicTextView textStorage] replaceCharactersInRange:NSMakeRange(0, 0)
												   withString:outputString];

	} else {
		NSBeep();
	}
}

- (IBAction)rollAdvanced:(id)sender
{
	NSInteger dicePool;
	NSInteger roll;
	NSString *rollToPrint;
	NSMutableArray *diceRolls;
	NSString *rollList;
	NSString *glitch;
	NSString *defaultTest;
	NSInteger i = 0;
	NSInteger hits = 0;
	NSInteger glitchcounter = 0;
	NSInteger glitchcheck = 0;	
	
	if (![advancedSkillPool intValue] && [advancedAttributePool intValue] >= 1) 
	{
		dicePool = [advancedAttributePool intValue] + [advancedEdgePool intValue] + [advancedModifierPool intValue] - 1;
		defaultTest = [[NSString alloc] initWithString:@"Default Test\n"];
	} else 
	{
		dicePool = [advancedAttributePool intValue] + [advancedSkillPool intValue] + [advancedEdgePool intValue];
		if (dicePool == [advancedEdgePool intValue]) {
            dicePool = dicePool + [advancedModifierPool intValue];
			defaultTest = [[NSString alloc] initWithString:@"Longshot Test\n"];
		} else {
            dicePool = dicePool + [advancedModifierPool intValue];
            defaultTest = [[NSString alloc] initWithString:@""];
	}
	}
	diceRolls = [[NSMutableArray alloc] init];
	rollList = [[NSString alloc] initWithString:@"Dice Rolls: "];
	
	
	if (dicePool > 0) {
		
		for (i = 0; i < dicePool; i++)
		{
			
			roll = (random() % 6) + 1;
			
			if (roll >= 5) {
				hits++;
				if (roll == 6 && [advancedEdgePool intValue] && defaultTest != @"Longshot Test\n") {
					dicePool++;
				}
			}
			
			if (roll == 1) {
				glitchcounter++;
			}
			
			[diceRolls insertObject:[NSNumber numberWithInt:roll] atIndex:i];
		}
		
		[diceRolls sortUsingSelector:@selector(compare:)];
		
		glitchcheck = ((dicePool/2) + (dicePool%2));
		
		if (glitchcounter >= glitchcheck) {
			if (hits > 0){
				glitch = [[NSString alloc] initWithString:@"Glitch\n"];
			} else if (hits == 0){
				glitch = [[NSString alloc] initWithString:@"Critical Glitch\n"];
			}
		} else {
			glitch = [[NSString alloc] initWithString:@" "];
		}
		
		for (i = dicePool-1; i >= 0; i--) {
			rollToPrint = [diceRolls objectAtIndex:i];
			rollList = [rollList stringByAppendingFormat:@"%@ ", rollToPrint];
		}
		
		NSString *outputString = [[NSString alloc] initWithFormat:@"%@Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", defaultTest, dicePool, rollList, hits, glitch];
		
		[[advancedTextView textStorage] replaceCharactersInRange:NSMakeRange(0, 0)
												   withString:outputString];
		
	} else {
		NSBeep();
	}
	
}
	

- (IBAction)basicRuleOfSix:(id)sender
{
    if ([sender state]) {
        basicRuleOfSix = 1;
    } else {
        basicRuleOfSix = 0;
    }
    NSLog(@"basicRuleofSix = %d", basicRuleOfSix);
}


@end
