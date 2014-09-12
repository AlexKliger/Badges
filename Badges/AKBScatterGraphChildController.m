//
//  BTScatterGraphChildController.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/31/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

// Third party libraries
#import "CorePlot-CocoaTouch.h"
// Controllers
#import "AKBScatterGraphChildController.h"
// Models
#import "AKBBadge.h"

@interface AKBScatterGraphChildController () <CPTScatterPlotDataSource>
{
    __weak AKBBadge *_badge;
    NSUInteger _longestStreak;
    
    __weak CPTGraphHostingView *_hostingView;
}
@end

@implementation AKBScatterGraphChildController

- (id)initWithBadge:(AKBBadge *)badge
{
    self = [super init];
    if (self) {
        _badge = badge;
        
        // Find the longest streak.
        _longestStreak = 0;
        for (NSArray *streak in [_badge allStreaks]) {
            if (streak.count > _longestStreak) {
                _longestStreak = streak.count;
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [self initPlot];
}

#pragma mark - Subview initialization methods
- (void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configurePlot];
    [self configureAxes];
}

- (void)configureHost
{
    // Set up the host view.
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    _hostingView = hostingView;
    _hostingView.allowPinchScaling = NO;
    [self.view addSubview:_hostingView];
    
}

- (void)configureGraph
{
    // Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:_hostingView.bounds];
    _hostingView.hostedGraph = graph;
    // Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.paddingBottom = 30.0;
    graph.paddingLeft = 40.0;
    graph.paddingTop = 20.0;
    graph.paddingRight = 10.0;
    graph.plotAreaFrame.masksToBorder = NO;
    // Set up the styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0;
    // Set up the title
    NSString *title = @"Streak Progress";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0, 0);
}

- (void)configurePlot
{
    // Set up the line style.
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blueColor];
    lineStyle.lineWidth = 2.5;
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor greenColor];
    // Set up the symbol style.
    CPTPlotSymbol *symbolStyle = [CPTPlotSymbol ellipsePlotSymbol];
    symbolStyle.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    symbolStyle.lineStyle = symbolLineStyle;
    symbolStyle.size = CGSizeMake(6, 6);
    // Set up the plot.
    CPTScatterPlot *streakPlot = [[CPTScatterPlot alloc] init];
    streakPlot.dataSource = self;
    streakPlot.dataLineStyle = lineStyle;
    streakPlot.plotSymbol = symbolStyle;
    // Set up the plot space.
    CGFloat xMin = 0.0;
    CGFloat xMax = (CGFloat)[_badge allStreaks].count;
    CGFloat yMin = 0.0;
    CGFloat yMax = (CGFloat)(_longestStreak + 1);
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_hostingView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    // Add the plot to the graph.
    CPTGraph *graph = _hostingView.hostedGraph;
    [graph addPlot:streakPlot toPlotSpace:plotSpace];
}

- (void)configureAxes
{
    // Set up the axis styles.
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 10.0;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 0.5;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    // Set up the number formatter
    NSNumberFormatter *axisNumberFormatter = [[NSNumberFormatter alloc] init];
    [axisNumberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    // Set up the graph's axis set.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_hostingView.hostedGraph.axisSet;
    // X-axis
    CPTXYAxis *xAxis = axisSet.xAxis;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    xAxis.majorIntervalLength = CPTDecimalFromInt(1);
    xAxis.title = @"Streaks";
    xAxis.titleOffset = 10.0;
    xAxis.titleTextStyle = axisTitleStyle;
    xAxis.axisLineStyle = axisLineStyle;
    xAxis.minorTickLineStyle = nil;
    xAxis.labelFormatter = axisNumberFormatter;
    // Y-Axis
    CPTXYAxis *yAxis = axisSet.yAxis;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    yAxis.majorIntervalLength = CPTDecimalFromInt(1);
    yAxis.title = @"Total days";
    yAxis.titleTextStyle = axisTitleStyle;
    yAxis.titleOffset = 20.0;
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.minorTickLineStyle = nil;
    yAxis.labelFormatter = axisNumberFormatter;
    
}

#pragma mark - Scatter plot data source methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_badge allStreaks].count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [NSDecimalNumber numberWithInteger:index];
            break;
        case CPTScatterPlotFieldY:
            return [NSDecimalNumber numberWithInteger:((NSMutableArray *)[[_badge allStreaks] objectAtIndex:index]).count];
            break;
        default:
            break;
    }
    return [NSDecimalNumber zero];
}

@end
