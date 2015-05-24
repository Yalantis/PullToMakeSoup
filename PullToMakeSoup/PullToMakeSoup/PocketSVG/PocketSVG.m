//
//  PocketSVG.m
//
//  Copyright (c) 2013 Ponderwell, Ariel Elkin, and Contributors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "PocketSVG.h"

NSInteger const maxPathComplexity	= 1000;
NSInteger const maxParameters		= 64;
NSInteger const maxTokenLength		= 64;
NSString* const separatorCharString = @"-, CcMmLlHhVvZzqQaAsS";
NSString* const commandCharString	= @"CcMmLlHhVvZzqQaAsS";
unichar const invalidCommand		= '*';



@interface Token : NSObject {
	@private
	unichar			command;
	NSMutableArray  *values;
}

- (id)initWithCommand:(unichar)commandChar;
- (void)addValue:(CGFloat)value;
- (CGFloat)parameter:(NSInteger)index;
- (NSInteger)valence;
@property(nonatomic, assign) unichar command;
@end


@implementation Token

- (id)initWithCommand:(unichar)commandChar {
	self = [self init];
    if (self) {
		command = commandChar;
		values = [[NSMutableArray alloc] initWithCapacity:maxParameters];
	}
	return self;
}

- (void)addValue:(CGFloat)value {
	[values addObject:[NSNumber numberWithDouble:value]];
}

- (CGFloat)parameter:(NSInteger)index {
	return [[values objectAtIndex:index] doubleValue];
}

- (NSInteger)valence
{
	return [values count];
}


@synthesize command;

@end


@interface PocketSVG ()

- (NSMutableArray *)parsePath:(NSString *)attr;
#if TARGET_OS_IPHONE
- (UIBezierPath *) generateBezier:(NSArray *)tokens;
#else
- (NSBezierPath *) generateBezier:(NSArray *)tokens;
#endif

- (void)reset;
- (void)appendSVGMCommand:(Token *)token;
- (void)appendSVGLCommand:(Token *)token;
- (void)appendSVGCCommand:(Token *)token;
- (void)appendSVGSCommand:(Token *)token;

@end


@implementation PocketSVG

@synthesize bezier;

+ (CGPathRef)pathFromSVGFileNamed:(NSString *)nameOfSVG
{
    PocketSVG *pocketSVG = [[PocketSVG alloc] initFromSVGPathNodeDAttr:[self parseSVGNamed:nameOfSVG]];
#if TARGET_OS_IPHONE
    return pocketSVG.bezier.CGPath;
#else
    return [PocketSVG getCGPathFromNSBezierPath:pocketSVG.bezier];
#endif
}

+ (CGPathRef)pathFromSVGFileAtURL:(NSURL *)svgFileURL
{
    NSString *svgString = [[self class] svgStringAtURL:svgFileURL];
    return [[self class] pathFromSVGString:svgString];
}

+ (CGPathRef)pathFromSVGString:(NSString *)svgString
{
    NSString *dAttribute = [self dStringFromRawSVGString:svgString];
    return [self pathFromDAttribute:dAttribute];
}

+ (CGPathRef)pathFromDAttribute:(NSString *)dAttribute
{
    PocketSVG *pocketSVG = [[PocketSVG alloc] initFromSVGPathNodeDAttr:dAttribute];
#if TARGET_OS_IPHONE
    return pocketSVG.bezier.CGPath;
#else
    return [PocketSVG getCGPathFromNSBezierPath:pocketSVG.bezier];
#endif
}

- (id)initFromSVGFileNamed:(NSString *)nameOfSVG{
    return [self initFromSVGPathNodeDAttr:[[self class] parseSVGNamed:nameOfSVG]];
}

- (id)initWithURL:(NSURL *)svgFileURL
{
    NSString *svgString = [[self class] svgStringAtURL:svgFileURL];
    
    return [self initFromSVGPathNodeDAttr:[[self class] dStringFromRawSVGString:svgString]];
}

+ (NSString *)svgStringAtURL:(NSURL *)svgFileURL
{
    NSError *error = nil;

    NSString *svgString = [NSString stringWithContentsOfURL:svgFileURL
                                                   encoding:NSStringEncodingConversionExternalRepresentation
                                                      error:&error];
    if (error) {
        NSLog(@"*** PocketSVG Error: Couldn't read contents of SVG file named %@:", svgFileURL);
        NSLog(@"%@", error);
        return nil;
    }
    return svgString;
}



/********
 Returns the content of the SVG's d attribute as an NSString
*/
+ (NSString *)parseSVGNamed:(NSString *)nameOfSVG{
    NSString *pathOfSVGFile = [[NSBundle bundleForClass:[self class]] pathForResource:nameOfSVG ofType:@"svg"];
    
    if(pathOfSVGFile == nil){
        NSLog(@"*** PocketSVG Error: No SVG file named \"%@\".", nameOfSVG);
        return nil;
    }
    
    NSError *error = nil;
    NSString *mySVGString = [[NSString alloc] initWithContentsOfFile:pathOfSVGFile encoding:NSStringEncodingConversionExternalRepresentation error:&error];
    
    if(error != nil){
        NSLog(@"*** PocketSVG Error: Couldn't read contents of SVG file named %@:", nameOfSVG);
        NSLog(@"%@", error);
        return nil;
    }

    return [[self class] dStringFromRawSVGString:mySVGString];
}

+ (NSString*)dStringFromRawSVGString:(NSString*)svgString{
    //Uncomment the two lines below to print the raw data of the SVG file:
    //NSLog(@"*** PocketSVG: Raw SVG data of %@:", nameOfSVG);
    //NSLog(@"%@", mySVGString);
    
    svgString = [svgString stringByReplacingOccurrencesOfString:@"id=" withString:@""];
    
    NSArray *components = [svgString componentsSeparatedByString:@"d="];
    
    if([components count] < 2){
        NSLog(@"*** PocketSVG Error: No d attribute found in SVG file.");
        return nil;
    }
    
    NSString *dString = [components lastObject];
    dString = [dString substringFromIndex:1];
    NSRange d = [dString rangeOfString:@"\""];
    dString = [dString substringToIndex:d.location];
    dString = [dString stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    NSArray *dStringWithPossibleWhiteSpace = [dString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    dString = [dStringWithPossibleWhiteSpace componentsJoinedByString:@""];
    
    //Uncomment the line below to print the raw path data of the SVG file:
    //NSLog(@"*** PocketSVG: Path data of %@ is: %@", nameOfSVG, dString);
    
    return dString;
}

- (id)initFromSVGPathNodeDAttr:(NSString *)attr
{
	self = [super init];
	if (self) {
		pathScale = 0;
		[self reset];
		separatorSet = [NSCharacterSet characterSetWithCharactersInString:separatorCharString];
		commandSet = [NSCharacterSet characterSetWithCharactersInString:commandCharString];
		tokens = [self parsePath:attr];
		bezier = [self generateBezier:tokens];
	}
	return self;
}


#pragma mark - Private methods

/*
	Tokenise pseudocode, used in parsePath below

	start a token
	eat a character
	while more characters to eat
		add character to token
		while in a token and more characters to eat
			eat character
			add character to token
		add completed token to store
		start a new token
	throw away empty token
*/

- (NSMutableArray *)parsePath:(NSString *)attr
{
	NSMutableArray *stringTokens = [NSMutableArray arrayWithCapacity: maxPathComplexity];
	
	NSInteger index = 0;
	while (index < [attr length]) {
        unichar	charAtIndex = [attr characterAtIndex:index];
        //Jagie:Skip whitespace
        if (charAtIndex == 32) {
            index ++;
            continue;
        }
		NSMutableString *stringToken = [[NSMutableString alloc] initWithCapacity:maxTokenLength];
		[stringToken setString:@""];
		
		if (charAtIndex != ',') {
			[stringToken appendString:[NSString stringWithFormat:@"%c", charAtIndex]];
		}
		if (![commandSet characterIsMember:charAtIndex] && charAtIndex != ',') {
			while ( (++index < [attr length]) && ![separatorSet characterIsMember:(charAtIndex = [attr characterAtIndex:index])] ) {
				[stringToken appendString:[NSString stringWithFormat:@"%c", charAtIndex]];
			}
		}
		else {
			index++;
		}
        
		if ([stringToken length]) {
			[stringTokens addObject:stringToken];
		}
	}
	
	if ([stringTokens count] == 0) {
		NSLog(@"*** PocketSVG Error: Path string is empty of tokens");
		return nil;
	}
	
	// turn the stringTokens array into Tokens, checking validity of tokens as we go
	tokens = [[NSMutableArray alloc] initWithCapacity:maxPathComplexity];
	index = 0;
	NSString *stringToken = [stringTokens objectAtIndex:index];
	unichar command = [stringToken characterAtIndex:0];
	while (index < [stringTokens count]) {
		if (![commandSet characterIsMember:command]) {
			NSLog(@"*** PocketSVG Error: Path string parse error: found float where expecting command at token %ld in path %s.",
					(long)index, [attr cStringUsingEncoding:NSUTF8StringEncoding]);
			return nil;
		}
		Token *token = [[Token alloc] initWithCommand:command];
		
		// There can be any number of floats after a command. Suck them in until the next command.
		while ((++index < [stringTokens count]) && ![commandSet characterIsMember:
				(command = [(stringToken = [stringTokens objectAtIndex:index]) characterAtIndex:0])]) {
			
			NSScanner *floatScanner = [NSScanner scannerWithString:stringToken];
			float value;
			if (![floatScanner scanFloat:&value]) {
				NSLog(@"*** PocketSVG Error: Path string parse error: expected float or command at token %ld (but found %s) in path %s.",
					  (long)index, [stringToken cStringUsingEncoding:NSUTF8StringEncoding], [attr cStringUsingEncoding:NSUTF8StringEncoding]);
				return nil;
			}
			// Maintain scale.
			pathScale = (fabsf(value) > pathScale) ? fabsf(value) : pathScale;
			[token addValue:value];
		}
		
		// now we've reached a command or the end of the stringTokens array
		[tokens	addObject:token];
	}
	//[stringTokens release];
	return tokens;
}

#if TARGET_OS_IPHONE
- (UIBezierPath *)generateBezier:(NSArray *)inTokens
{
	bezier = [[UIBezierPath alloc] init];
#else
- (NSBezierPath *)generateBezier:(NSArray *)inTokens
{
    bezier = [[NSBezierPath alloc] init];
#endif

	[self reset];
	for (Token *thisToken in inTokens) {
		unichar command = [thisToken command];
		switch (command) {
			case 'M':
			case 'm':
				[self appendSVGMCommand:thisToken];
				break;
			case 'L':
			case 'l':
			case 'H':
			case 'h':
			case 'V':
			case 'v':
				[self appendSVGLCommand:thisToken];
				break;
			case 'C':
			case 'c':
				[self appendSVGCCommand:thisToken];
				break;
			case 'S':
			case 's':
				[self appendSVGSCommand:thisToken];
				break;
			case 'Z':
			case 'z':
				[bezier closePath];
				break;
			default:
				NSLog(@"*** PocketSVG Error: Cannot process command : '%c'", command);
				break;
		}
	}
#if !TARGET_OS_IPHONE
    
//-(CGAffineTransform)uiKitCTM:( CGRect) bounds
//    {
//        return CGAffineTransformConcat( CGAffineTransformMakeScale( 1.0f, -1.0f ), CGAffineTransformMakeTranslation( 0.0f, viewBounds.size.height ));
//    };
    
//    NSAffineTransform* xform = [NSAffineTransform transform];
//    [xform rotateByDegrees:180];
//    [bezier transformUsingAffineTransform:xform];
    
//    CGContextRef graphicsContext = [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSaveGState(graphicsContext);
//    CGContextTranslateCTM(graphicsContext, 0.0, bezier.bounds.size.heigth);
//    CGContextScaleCTM(graphicsContext, 1.0, -1.0);
//    CGContextDrawImage(graphicsContext, bezier, CGRectMake(0, 0, imageWidth, imageHeight));
//    CGContextRestoreGState(graphicsContext);
//    [bezier transformUsingAffineTransform:(NSAffineTransform)(CGAffineTransformConcat( CGAffineTransformMakeScale( 1.0f, -1.0f ), CGAffineTransformMakeTranslation( 0.0f, bezier.bounds.size.height )))];
    
#endif
	return bezier;
}

- (void)reset
{
	lastPoint = CGPointMake(0, 0);
	validLastControlPoint = NO;
}

- (void)appendSVGMCommand:(Token *)token
{
	validLastControlPoint = NO;
	NSInteger index = 0;
	BOOL first = YES;
	while (index < [token valence]) {
		CGFloat x = [token parameter:index] + ([token command] == 'm' ? lastPoint.x : 0);
		if (++index == [token valence]) {
			NSLog(@"*** PocketSVG Error: Invalid parameter count in M style token");
			return;
		}
		CGFloat y = [token parameter:index] + ([token command] == 'm' ? lastPoint.y : 0);
		lastPoint = CGPointMake(x, y);
		if (first) {
			[bezier moveToPoint:lastPoint];
			first = NO;
		}
		else {
#if TARGET_OS_IPHONE
			[bezier addLineToPoint:lastPoint];
#else
			[bezier lineToPoint:NSPointFromCGPoint(lastPoint)];
#endif
		}
		index++;
	}
}

- (void)appendSVGLCommand:(Token *)token
{
	validLastControlPoint = NO;
	NSInteger index = 0;
	while (index < [token valence]) {
		CGFloat x = 0;
		CGFloat y = 0;
		switch ( [token command] ) {
			case 'l':
				x = lastPoint.x;
				y = lastPoint.y;
			case 'L':
				x += [token parameter:index];
				if (++index == [token valence]) {
					NSLog(@"*** PocketSVG Error: Invalid parameter count in L style token");
					return;
				}
				y += [token parameter:index];
				break;
			case 'h' :
				x = lastPoint.x;				
			case 'H' :
				x += [token parameter:index];
				y = lastPoint.y;
				break;
			case 'v' :
				y = lastPoint.y;
			case 'V' :
				y += [token parameter:index];
				x = lastPoint.x;
				break;
			default:
				NSLog(@"*** PocketSVG Error: Unrecognised L style command.");
				return;
		}
		lastPoint = CGPointMake(x, y);
#if TARGET_OS_IPHONE
		[bezier addLineToPoint:lastPoint];
#else
		[bezier lineToPoint:NSPointFromCGPoint(lastPoint)];
#endif
		index++;
	}
}

- (void)appendSVGCCommand:(Token *)token
{
	NSInteger index = 0;
	while ((index + 5) < [token valence]) {  // we must have 6 floats here (x1, y1, x2, y2, x, y).
		CGFloat x1 = [token parameter:index++] + ([token command] == 'c' ? lastPoint.x : 0);
		CGFloat y1 = [token parameter:index++] + ([token command] == 'c' ? lastPoint.y : 0);
		CGFloat x2 = [token parameter:index++] + ([token command] == 'c' ? lastPoint.x : 0);
		CGFloat y2 = [token parameter:index++] + ([token command] == 'c' ? lastPoint.y : 0);
		CGFloat x  = [token parameter:index++] + ([token command] == 'c' ? lastPoint.x : 0);
		CGFloat y  = [token parameter:index++] + ([token command] == 'c' ? lastPoint.y : 0);
		lastPoint = CGPointMake(x, y);
#if TARGET_OS_IPHONE
		[bezier addCurveToPoint:lastPoint 
				  controlPoint1:CGPointMake(x1,y1) 
				  controlPoint2:CGPointMake(x2, y2)];
#else
		[bezier curveToPoint:NSPointFromCGPoint(lastPoint)
			   controlPoint1:NSPointFromCGPoint(CGPointMake(x1,y1))
			   controlPoint2:NSPointFromCGPoint(CGPointMake(x2, y2))];
#endif
        lastControlPoint = CGPointMake(x2, y2);
		validLastControlPoint = YES;
	}
	if (index == 0) {
		NSLog(@"*** PocketSVG Error: Insufficient parameters for C command");
	}
}

- (void)appendSVGSCommand:(Token *)token
{
	if (!validLastControlPoint) {
		NSLog(@"*** PocketSVG Error: Invalid last control point in S command");
	}
	NSInteger index = 0;
	while ((index + 3) < [token valence]) {  // we must have 4 floats here (x2, y2, x, y).
		CGFloat x1 = lastPoint.x + (lastPoint.x - lastControlPoint.x); // + ([token command] == 's' ? lastPoint.x : 0);
		CGFloat y1 = lastPoint.y + (lastPoint.y - lastControlPoint.y); // + ([token command] == 's' ? lastPoint.y : 0);
		CGFloat x2 = [token parameter:index++] + ([token command] == 's' ? lastPoint.x : 0);
		CGFloat y2 = [token parameter:index++] + ([token command] == 's' ? lastPoint.y : 0);
		CGFloat x  = [token parameter:index++] + ([token command] == 's' ? lastPoint.x : 0);
		CGFloat y  = [token parameter:index++] + ([token command] == 's' ? lastPoint.y : 0);
		lastPoint = CGPointMake(x, y);
#if TARGET_OS_IPHONE
		[bezier addCurveToPoint:lastPoint 
				  controlPoint1:CGPointMake(x1,y1)
				  controlPoint2:CGPointMake(x2, y2)];
#else
		[bezier curveToPoint:NSPointFromCGPoint(lastPoint)
			   controlPoint1:NSPointFromCGPoint(CGPointMake(x1,y1)) 
			   controlPoint2:NSPointFromCGPoint(CGPointMake(x2, y2))];
#endif
		lastControlPoint = CGPointMake(x2, y2);
		validLastControlPoint = YES;
	}
	if (index == 0) {
		NSLog(@"*** PocketSVG Error: Insufficient parameters for S command");
	}
}
    
#if !TARGET_OS_IPHONE
//NSBezierPaths don't have a CGPath property, so we need to fetch their CGPath manually.
//This comes from the "Creating a CGPathRef From an NSBezierPath Object" section of
//https://developer.apple.com/library/mac/#documentation/cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html

+ (CGPathRef)getCGPathFromNSBezierPath:(NSBezierPath *)quartzPath
{
    int i;
    NSInteger numElements;
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = [quartzPath elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
        
        for (i = 0; i < numElements; i++)
        {
            switch ([quartzPath elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    //TODO:
    //At this stage, immutablePath is upside down. I'm currently flipping it back using CGAffineTransforms,
    //the path rotates fine, but its positioning needs to be fixed.
    
    CGAffineTransform flip = CGAffineTransformMake(1, 0, 0, -1, 0, CGPathGetBoundingBox(immutablePath).size.height);
    CGAffineTransform moveDown = CGAffineTransformMakeTranslation(0, -100);
    CGAffineTransform trans = CGAffineTransformConcat(flip, moveDown);
    CGPathRef betterPath = CGPathCreateCopyByTransformingPath(immutablePath, &trans);
    return betterPath;
}
#endif


@end
