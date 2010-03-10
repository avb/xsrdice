//
//  XSRDice.h
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

#import <Cocoa/Cocoa.h>


@interface XSRDice : NSObject {
    NSInteger dieRoll;
	NSInteger dicePool;
    NSInteger hits;
    NSInteger glitchCounter;
    NSMutableArray *diceRolls;
    NSString *defaultTest;
    
	NSInteger basicRuleOfSix;
	
	NSCalendarDate *rollDate;
    
	IBOutlet NSTextField *basicDicePool;
	IBOutlet NSTextField *advancedAttributePool;
	IBOutlet NSTextField *advancedSkillPool;
	IBOutlet NSTextField *advancedEdgePool;
	IBOutlet NSTextField *advancedModifierPool;
	
	IBOutlet NSTextView *outputTextView;
    IBOutlet NSTabView *tabView;


}

- (id)init;
- (void)rollDice;

@property NSInteger dieRoll;
@property NSInteger dicePool;
@property NSInteger hits;
@property NSInteger glitchCounter;
@property (retain) NSMutableArray *diceRolls;
@property (retain) NSString *defaultTest;

- (IBAction)rollBasic:(id)sender;
- (IBAction)rollAdvanced:(id)sender;
- (IBAction)reRollAddEdge:(id)sender;
- (IBAction)reRollMissed:(id)sender;
- (IBAction)basicRuleOfSix:(id)sender;

@end
