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

- (id) init 
{
    if (self = [super init])
    {
        self.diceRolls = [[NSMutableArray alloc] init];
    }
    return self;
}

@synthesize dicePool;
@synthesize hits;
@synthesize diceRolls;

- (IBAction)rollBasic:(id)sender
{
    NSInteger roll;
    NSInteger glitchcounter = 0;
    NSInteger i;
    
	NSString *rollList;
	
    
    self.dicePool = basicDicePool.intValue;
    self.diceRolls.removeAllObjects;
    self.hits = 0;
    
	rollList = [[NSString alloc] initWithString:@"Dice Rolls: "];


	if (self.dicePool > 0) 
	{
		for (i = 0; i < self.dicePool; i++)      // Roll Dice
		{
			roll = (random() % 6) + 1;
			
			if (roll >= 5) {        // Hit Counter
				self.hits++;
				if (roll == 6 && basicRuleOfSix == 1) {
					self.dicePool++;
				}
			}
			
			if (roll == 1) {    // Glitch Counter
				glitchcounter++;
			}
			
			[self.diceRolls insertObject:[NSNumber numberWithInt:roll] atIndex:i];   // Insert roll into array
		}

		[self.diceRolls sortUsingSelector:@selector(compare:)];      // Order rolls High to Low
		
        NSInteger glitchcheck = 0;
		glitchcheck = ((self.dicePool/2) + (self.dicePool%2));
		
        NSString *glitch;       // Set Glitch Output
		if (glitchcounter >= glitchcheck) {
			if (self.hits > 0){
				glitch = [[NSString alloc] initWithString:@"Glitch\n"];
			} else if (self.hits == 0){
				glitch = [[NSString alloc] initWithString:@"Critical Glitch\n"];
			}
		} else {
			glitch = [[NSString alloc] initWithString:@" "];
		}
		
        NSString *rollToPrint;      // Set Roll Output
		for (i = self.dicePool-1; i >= 0; i--) {
			rollToPrint = [self.diceRolls objectAtIndex:i];
			rollList = [rollList stringByAppendingFormat:@"%@ ", rollToPrint];
		}
		
		NSString *outputString = [[NSString alloc] initWithFormat:@"Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", self.dicePool, rollList, self.hits, glitch];
		
		
		[[basicTextView textStorage] replaceCharactersInRange:NSMakeRange(0, 0)
												   withString:outputString];

	} else {
		NSBeep();
	}
}

- (IBAction)rollAdvanced:(id)sender
{
	NSInteger roll;
	NSString *rollToPrint;
	NSString *rollList;
	NSString *glitch;
	NSString *defaultTest;
	NSInteger i = 0;
	NSInteger glitchcounter = 0;
	NSInteger glitchcheck = 0;	
	
    self.hits = 0;
    
	if (![advancedSkillPool intValue] && [advancedAttributePool intValue] >= 1) 
	{
		self.dicePool = advancedAttributePool.intValue + advancedEdgePool.intValue + advancedModifierPool.intValue - 1;
		defaultTest = [[NSString alloc] initWithString:@"Default Test\n"];
	} else 
	{
		self.dicePool = advancedAttributePool.intValue + advancedSkillPool.intValue + advancedEdgePool.intValue;
		if (self.dicePool == advancedEdgePool.intValue) {
            self.dicePool = self.dicePool + advancedModifierPool.intValue;
			defaultTest = [[NSString alloc] initWithString:@"Longshot Test\n"];
		} else {
            self.dicePool = self.dicePool + advancedModifierPool.intValue;
            defaultTest = [[NSString alloc] initWithString:@""];
	}
	}
    
    self.diceRolls.removeAllObjects;
    
	rollList = [[NSString alloc] initWithString:@"Dice Rolls: "];
	
	
	if (self.dicePool > 0) {
		
		for (i = 0; i < self.dicePool; i++)
		{
			
			roll = (random() % 6) + 1;
			
			if (roll >= 5) {
				self.hits++;
				if (roll == 6 && advancedEdgePool.intValue && defaultTest != @"Longshot Test\n") {
					self.dicePool++;
				}
			}
			
			if (roll == 1) {
				glitchcounter++;
			}
			
			[self.diceRolls insertObject:[NSNumber numberWithInt:roll] atIndex:i];
		}
		
		[self.diceRolls sortUsingSelector:@selector(compare:)];
		
		glitchcheck = ((self.dicePool/2) + (self.dicePool%2));
		
		if (glitchcounter >= glitchcheck) {
			if (self.hits > 0){
				glitch = [[NSString alloc] initWithString:@"Glitch\n"];
			} else if (self.hits == 0){
				glitch = [[NSString alloc] initWithString:@"Critical Glitch\n"];
			}
		} else {
			glitch = [[NSString alloc] initWithString:@" "];
		}
		
		for (i = self.dicePool-1; i >= 0; i--) {
			rollToPrint = [self.diceRolls objectAtIndex:i];
			rollList = [rollList stringByAppendingFormat:@"%@ ", rollToPrint];
		}
		
		NSString *outputString = [[NSString alloc] initWithFormat:@"%@Total Dice Pool: %d \n%@\nNumber of Hits: %d\n%@\n", defaultTest, self.dicePool, rollList, self.hits, glitch];
		
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
}


@end
