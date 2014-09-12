//
//  BTBarGraphChildController.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/31/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

// Third party libraries
#import "CorePlot-CocoaTouch.h"
// Controllers
#import "AKBBarGraphChildController.h"
// Models
#import "AKBBadge.h"

@interface AKBBarGraphChildController () <CPTBarPlotDataSource>
{
    __weak AKBBadge *_badge;
    NSUInteger _longestStreak;
    NSUInteger _mostCommonStreakLength;
    NSMutableArray *_streakFrequencyArray;
    
    __weak CPTGraphHostingView *_hostingView;
}
@end

@implementation AKBBarGraphChildController

#pragma mark - View controller lifecycle methods
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
        
        // Set up the bar plot data model.
        _streakFrequencyArray = [NSMutableArray array];
        for (int i = 0; i <= _longestStreak; ++i) {
            [_streakFrequencyArray addObject:[NSMutableArray array]];
        }
        
        // Distribute streaks by length.
        for (NSMutableArray *streak in [badge allStreaks]) {
            [[_streakFrequencyArray objectAtIndex:streak.count] addObject:streak];
        }
        
        // Find the most common streak length
        _mostCommonStreakLength = 0;
        for (NSMutableArray *streaks in _streakFrequencyArray) {
            if (streaks.count > _mostCommonStreakLength) {
                _mostCommonStreakLength = streaks.count;
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
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    _hostingView = hostingView;
    _hostingView.allowPinchScaling = NO;
    [self.view addSubview:_hostingView];
}

- (void)configureGraph
{
    // Create the graph.
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:_hostingView.bounds];
    _hostingView.hostedGraph = graph;
    // Set up the graph.
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.paddingBottom = 30.0;
    graph.paddingLeft = 40.0;
    graph.paddingTop = 20.0;
    graph.paddingRight = 10.0;
    // Set up the title style.
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0;
    // Set up the title.
    NSString *title = @"Streak Frequency Distribution";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0, 0);
}

- (void)configurePlot
{
    // Set up the plot space.
    CGFloat xMin = 0.0;
    CGFloat xMax = (CGFloat)(_longestStreak + 1.0);
    CGFloat yMin = 0.0;
    CGFloat yMax = (CGFloat)(_mostCommonStreakLength + 1.0);
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_hostingView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    // Set up the line style.
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    // Set up the plot.
    CPTBarPlot *histogramPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    histogramPlot.dataSource = self;
    histogramPlot.barWidth = CPTDecimalFromFloat(0.20);
    histogramPlot.lineStyle = barLineStyle;
    // Add the plot to the graph.
    CPTGraph *graph = _hostingView.hostedGraph;
    [graph addPlot:histogramPlot toPlotSpace:graph.defaultPlotSpace];
}

- (void)configureAxes
{
    // Set up axis styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 10.0;
    CPTMutableTextStyle *axisLabelStyle = [CPTMutableTextStyle textStyle];
    axisLabelStyle.fontSize = 10;
    axisLabelStyle.color = [CPTColor whiteColor];
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
    xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    xAxis.majorIntervalLength = CPTDecimalFromInt(1);
    xAxis.title = @"Total days";
    xAxis.titleOffset = 19.0;
    xAxis.titleTextStyle = axisTitleStyle;
    xAxis.labelTextStyle = axisLabelStyle;
    xAxis.axisLineStyle = axisLineStyle;
    xAxis.minorTickLineStyle = nil;
    xAxis.labelFormatter = axisNumberFormatter;
    // Y-axis
    CPTXYAxis *yAxis = axisSet.yAxis;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    yAxis.majorIntervalLength = CPTDecimalFromInt(1);
    yAxis.title = @"Total streaks";
    yAxis.titleTextStyle = axisTitleStyle;
    yAxis.titleOffset = 20.0;
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.minorTickLineStyle = nil;
    yAxis.labelFormatter = axisNumberFormatter;
}

#pragma mark - Bar plot data source methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _streakFrequencyArray.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (_streakFrequencyArray.count > 0)) {
        return [NSDecimalNumber numberWithUnsignedInteger:[[_streakFrequencyArray objectAtIndex:index] count]];
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

@end
