//
//  PocketSVG.h
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

#import <UIKit/UIKit.h>

@interface PocketSVG : NSObject {
	@private
	float			pathScale;
#if TARGET_OS_IPHONE
	UIBezierPath    *bezier;
#else
	NSBezierPath    *bezier;
#endif
	CGPoint			lastPoint;
	CGPoint			lastControlPoint;
	BOOL			validLastControlPoint;
	NSCharacterSet  *separatorSet;
	NSCharacterSet  *commandSet;
    
    NSMutableArray  *tokens;
}
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIBezierPath *bezier;
#else
@property(nonatomic, readonly) NSBezierPath *bezier;
#endif


/*!
 *  Returns a CGPathRef corresponding to the path represented by a local SVG file's d attribute.
 *
 *  @param nameOfSVG The name of the SVG file. The methods looks for a SVG with the specified in the application's main bundle.
 *
 *  @return A CGPathRef object for the SVG in the specified file, or nil if the object could not be found or could not be parsed.
 */
+ (CGPathRef)pathFromSVGFileNamed:(NSString *)nameOfSVG;

/*!
 *  Returns a CGPathRef corresponding to the path represented by a local SVG file's D attribute
 *
 *  @param svgFileURL The URL to the file.
 *
 *  @return A CGPathRef object for the SVG in the specified file, or nil if the object could not be found or could not be parsed.
 */
+ (CGPathRef)pathFromSVGFileAtURL:(NSURL *)svgFileURL;

/*!
 *  Returns a CGPathRef corresponding to the path represented by a string with SVG formatted contents.
 *
 *  @param svgString The string containing the SVG formatted path.
 *
 *  @return A CGPathRef object for the SVG in the string, or nil if no path is found or the string could not be parsed.
 */
+ (CGPathRef)pathFromSVGString:(NSString *)svgString;

/*!
 *  Returns a CGPathRef corresponding to the path represented by a string with the contents of the d attribute of a path node in an SVG file.
 *
 *  @param dAttribute The string containing the d attribute with the path.
 *
 *  @return A CGPathRef object for the path in the string, or nil if no path is found or the string could not be parsed.
 */
+ (CGPathRef)pathFromDAttribute:(NSString *)dAttribute;


/*!
 *  Returns a PocketSVG object initialized with nameOfSVG
 *
 *  @param nameOfSVG The name of the SVG file.  The methods looks for a SVG with the specified in the application's main bundle.
 *
 *  @return The PocketSVG object for the specified file, or nil if the object could not be found or could not be parsed.
 */
- (instancetype)initFromSVGFileNamed:(NSString *)nameOfSVG __attribute__((deprecated));

/*!
 *  Returns a PocketSVG object initialized with svgFileURL
 *
 *  @param svgFileURL The URL to the file.
 *
 *  @return The PocketSVG object for the specified file, or nil if the object could not be found or could not be parsed.
 */
- (instancetype)initWithURL:(NSURL *)svgFileURL __attribute__((deprecated));



#if !TARGET_OS_IPHONE
+ (CGPathRef)getCGPathFromNSBezierPath:(NSBezierPath *)quartzPath;
#endif

@end
