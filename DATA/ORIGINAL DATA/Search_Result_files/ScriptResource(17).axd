﻿// Name:        AreaChart.AreaChart.debug.js
// Assembly:    AjaxControlToolkit
// Version:     4.1.7.725
// FileVersion: 4.1.7.0725
Type.registerNamespace("Sys.Extended.UI");

Sys.Extended.UI.AreaChart = function (element) {
    Sys.Extended.UI.AreaChart.initializeBase(this, [element]);
    var id = this.get_id();
    id = id.replace("_ctl00", "");
    this._parentDiv = document.getElementById(id + "__ParentDiv");

    this._chartWidth = '300';
    this._chartHeight = '300';
    this._chartTitle = '';
    this._categoriesAxis = '';
    this._series = null;
    this._chartType = Sys.Extended.UI.AreaChartType.Basic;
    this._theme = 'AreaChart';
    this._valueAxisLines = 9;
    this._chartTitleColor = '';
    this._valueAxisLineColor = '';
    this._categoryAxisLineColor = '';
    this._baseLineColor = '';

    this.yMax = 0;
    this.yMin = 0;    
    this.roundedTickRange = 0;
    this.startX = 0;
    this.startY = 0;
    this.endX = 0;
    this.endY = 0;
    this.xInterval = 0;
    this.yInterval = 0;
    this.arrXAxis;
    this.arrXAxisLength = 0;
    this.charLength = 3.5;
    this.arrCombinedData = null;
}

Sys.Extended.UI.AreaChart.prototype = {

    initialize: function () {
        Sys.Extended.UI.AreaChart.callBaseMethod(this, "initialize");

        if (!document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Image", "1.1")) {
            throw 'Current version of browser does not support SVG.'
        }

        if (this._valueAxisLines == 0) {
            this._valueAxisLines = 9;
        }

        this.generateAreaChart();
    },

    dispose: function () {
        Sys.Extended.UI.AreaChart.callBaseMethod(this, "dispose");
    },

    generateAreaChart: function () {
        this.arrXAxis = this._categoriesAxis.split(',');
        this.arrXAxisLength = this.arrXAxis.length;

        this.calculateMinMaxValues();
        this.calculateInterval();
        this.calculateValueAxis();

        var svgContents = this.initializeSVG();
        svgContents = svgContents + String.format('<text x="{0}" y="{1}" id="ChartTitle" style="fill:{3}">{2}</text>', parseInt(this._chartWidth) / 2 - (this._chartTitle.length * this.charLength), parseInt(this._chartHeight) * 5 / 100, this._chartTitle, this._chartTitleColor);

        svgContents = svgContents + this.drawBackgroundHorizontalLines();
        svgContents = svgContents + this.drawBackgroundVerticalLines();
        svgContents = svgContents + this.drawBaseLines();
        svgContents = svgContents + this.drawLegendArea();
        svgContents = svgContents + this.drawAxisValues();
        this._parentDiv.innerHTML = svgContents;
        this.drawAreas();
    },

    calculateInterval: function () {
        this.startX = (this._chartWidth * 10 / 100) + 0.5;
        this.endX = parseInt(this._chartWidth) - 4.5;

        if (this.yMin >= 0)
            this.startY = Math.round(parseInt(this._chartHeight) - (parseInt(this._chartHeight) * 24 / 100)) + 0.5;
        else
            this.startY = Math.round(parseInt(this._chartHeight) - (parseInt(this._chartHeight) * 12 / 100)) / 2 + 0.5;

        this.yInterval = this.startY / (this._valueAxisLines + 1);
    },

    calculateMinMaxValues: function () {
        var seriesMax;
        var seriesMin;
        var arrData;
        if (this._chartType == Sys.Extended.UI.AreaChartType.Basic) {
            for (var i = 0; i < this._series.length; i++) {
                arrData = this._series[i].Data;
                seriesMax = Math.max.apply(null, arrData);
                seriesMin = Math.min.apply(null, arrData);
                if (i == 0) {
                    this.yMax = seriesMax;
                    this.yMin = seriesMin;
                }
                else {
                    if (seriesMax > this.yMax)
                        this.yMax = seriesMax;
                    if (seriesMin < this.yMin)
                        this.yMin = seriesMin;
                }
            }
        }
        else {
            for (var i = 0; i < this._series.length; i++) {
                arrData = new Array();
                for (var j = 0; j < this._series[i].Data.length; j++) {
                    arrData[j] = this._series[i].Data[j];
                }
                if (this.arrCombinedData == null)
                    this.arrCombinedData = arrData;
                else {
                    for (j = 0; j < arrData.length; j++) {
                        this.arrCombinedData[j] = parseFloat(this.arrCombinedData[j]) + parseFloat(arrData[j]);
                    }
                }
            }

            for (var i = 0; i < this._series.length; i++) {
                seriesMin = Math.min.apply(null, this._series[i].Data);
                if (i == 0) {
                    this.yMin = seriesMin;
                }
                else {
                    if (seriesMin < this.yMin)
                        this.yMin = seriesMin;
                }
            }

            this.yMax = Math.max.apply(null, this.arrCombinedData);
        }

        if (this.yMin < 0) {
            this._valueAxisLines = Math.round(this._valueAxisLines / 2);
        }
    },

    calculateValueAxis: function () {
        var range;
        var unroundedTickSize;
        var x;
        var pow10x;

        if (this.yMin >= 0) {
            range = this.yMax;
        }
        else {
            range = this.yMax > Math.abs(this.yMin) ? this.yMax : Math.abs(this.yMin);
        }

        unroundedTickSize = range / (this._valueAxisLines - 1);
        if (unroundedTickSize < 1) {
            this.roundedTickRange = unroundedTickSize.toFixed(1);
        }
        else {
            x = Math.ceil((Math.log(unroundedTickSize) / Math.log(10)) - 1);
            pow10x = Math.pow(10, x);
            this.roundedTickRange = Math.ceil(unroundedTickSize / pow10x) * pow10x;
        }
        this.startX = this.startX + (this.roundedTickRange * 10 * this._valueAxisLines / 10).toString().length * this.charLength;
    },

    drawBackgroundHorizontalLines: function () {
        var horizontalLineContents = '';
        for (var i = 1; i <= this._valueAxisLines; i++) {
            horizontalLineContents = horizontalLineContents + String.format('<path d="M{0} {2} {1} {2}" id="HorizontalLine" style="stroke:{3}"></path>', this.startX, this.endX, this.startY - (this.yInterval * i), this._categoryAxisLineColor);
        }

        if (this.yMin < 0) {
            for (var i = 1; i <= this._valueAxisLines; i++) {
                horizontalLineContents = horizontalLineContents + String.format('<path d="M{0} {2} {1} {2}" id="HorizontalLine" style="stroke:{3}"></path>', this.startX, this.endX, this.startY + (this.yInterval * i), this._categoryAxisLineColor);
            }
        }
        return horizontalLineContents;
    },

    drawBackgroundVerticalLines: function () {
        var verticalLineContents = '';
        this.xInterval = Math.round((parseInt(this._chartWidth) - this.startX) / this.arrXAxisLength);

        for (var i = 0; i < this.arrXAxisLength; i++) {
            verticalLineContents = verticalLineContents + String.format('<path id="VerticalLine" d="M{0} {1} {0} {2}" style="stroke:{3}"></path>', ((parseInt(this._chartWidth) - 5) - (this.xInterval * i)), (this.startY - (this.yInterval * this._valueAxisLines)), this.startY, this._valueAxisLineColor);
        }

        if (this.yMin < 0) {
            for (var i = 0; i < this.arrXAxisLength; i++) {
                verticalLineContents = verticalLineContents + String.format('<path id="VerticalLine" d="M{0} {1} {0} {2}" style="stroke:{3}"></path>', ((parseInt(this._chartWidth) - 5) - (this.xInterval * i)), (this.startY + (this.yInterval * this._valueAxisLines)), this.startY, this._valueAxisLineColor);
            }
        }
        return verticalLineContents;
    },

    drawBaseLines: function () {
        var baseLineContents = '';

        baseLineContents = baseLineContents + String.format('<path d="M{0} {1} {2} {1}" id="BaseLine" style="stroke:{3}"></path>', this.startX, this.startY, this.endX, this._baseLineColor);
        baseLineContents = baseLineContents + String.format('<path d="M{0} {1} {0} {2}" id="BaseLine" style="stroke:{3}"></path>', this.startX, (this.startY - (this.yInterval * this._valueAxisLines)), this.startY, this._baseLineColor);
        baseLineContents = baseLineContents + String.format('<path d="M{0} {1} {0} {2}" id="BaseLine" style="stroke:{3}"></path>', this.startX, this.startY, this.startY + 4, this._baseLineColor);

        for (var i = 0; i < this.arrXAxisLength; i++) {
            baseLineContents = baseLineContents + String.format('<path d="M{0} {1} {0} {2}" id="BaseLine" style="stroke:{3}"></path>', ((parseInt(this._chartWidth) - 5) - (this.xInterval * i)), this.startY, this.startY + 4, this._baseLineColor);
        }

        for (var i = 0; i <= this._valueAxisLines; i++) {
            baseLineContents = baseLineContents + String.format('<path d="M{0} {2} {1} {2}" id="BaseLine" style="stroke:{3}"></path>', this.startX - 4, this.startX, this.startY - (this.yInterval * i), this._baseLineColor);
        }

        if (this.yMin < 0) {
            baseLineContents = baseLineContents + String.format('<path d="M{0} {1} {0} {2}" id="BaseLine" style="stroke:{3}"></path>', this.startX, (this.startY + (this.yInterval * this._valueAxisLines)), this.startY, this._baseLineColor);
            for (var i = 1; i <= this._valueAxisLines; i++) {
                baseLineContents = baseLineContents + String.format('<path d="M{0} {2} {1} {2}" id="BaseLine" style="stroke:{3}"></path>', this.startX - 4, this.startX, this.startY + (this.yInterval * i), this._baseLineColor);
            }
        }
        return baseLineContents;
    },

    drawLegendArea: function () {
        var legendContents = '';
        var legendAreaStartHeight = (parseInt(this._chartHeight) * 82 / 100) + 5;        
        var legendBoxWidth = 7.5;
        var legendBoxHeight = 7.5;
        var spaceInLegendContents = 5;

        var legendCharLength = 0;
        for (var i = 0; i < this._series.length; i++) {
            legendCharLength = legendCharLength + this._series[i].Name.length;
        }
        var legendAreaWidth = Math.round((legendCharLength * 5) / 2) + Math.round((legendBoxWidth + (spaceInLegendContents * 2)) * this._series.length);
        var isLegendNextLine = false;
        if (legendAreaWidth > parseInt(this._chartWidth) / 2) {
            legendAreaWidth = legendAreaWidth / 2;
            isLegendNextLine = true;
        }

        legendContents = legendContents + '<g>';
        legendContents = legendContents + String.format('<path d="M{0} {1} {2} {1} {2} {3} {0} {3} z" id="LegendArea" stroke=""></path>', parseInt(this._chartWidth) * 50 / 100 - (legendAreaWidth / 2), legendAreaStartHeight, Math.round(parseInt(this._chartWidth) * 50 / 100 + (legendCharLength * 5)) + Math.round((legendBoxWidth + (spaceInLegendContents * 2)) * this._series.length), Math.round(parseInt(this._chartHeight) * 97.5 / 100));

        var startText = parseInt(this._chartWidth) * 40 / 100 - (legendAreaWidth / 2) + legendBoxWidth + spaceInLegendContents;
        var nextStartText = startText;
        var startLegend = parseInt(this._chartWidth) * 40 / 100 - (legendAreaWidth / 2);
        var nextStartLegend = startLegend;

        for (var i = 0; i < this._series.length; i++) {
            if (isLegendNextLine && i == Math.round(this._series.length / 2)) {
                startText = parseInt(this._chartWidth) * 40 / 100 - (legendAreaWidth / 2) + legendBoxWidth + spaceInLegendContents;
                nextStartText = startText;
                startLegend = parseInt(this._chartWidth) * 40 / 100 - (legendAreaWidth / 2);
                nextStartLegend = startLegend;
                legendAreaStartHeight = (parseInt(this._chartHeight) * 89 / 100) + 5;
                isLegendNextLine = false;
            }
            startLegend = nextStartLegend;
            startText = nextStartText;
            legendContents = legendContents + String.format('<path d="M{0} {1} {2} {1} {2} {3} {0} {3} z" id="Legend{4}" style="fill:{5}"></path>', startLegend, legendAreaStartHeight + legendBoxHeight, startLegend + legendBoxWidth, legendAreaStartHeight + 15, i + 1, this._series[i].AreaColor);
            legendContents = legendContents + String.format('<text x="{0}" y="{1}" id="LegendText">{2}</text>', startText, legendAreaStartHeight + 15, this._series[i].Name);
            if (this._series[i].Name.length > 10) {
                nextStartLegend = startLegend + (this._series[i].Name.length * 5) + legendBoxWidth + (spaceInLegendContents * 2);
                nextStartText = startText + (this._series[i].Name.length * 5) + legendBoxWidth + (spaceInLegendContents * 2);
            }
            else {
                nextStartLegend = nextStartLegend + (this._series[i].Name.length * 6) + legendBoxWidth + (spaceInLegendContents * 2);
                nextStartText = nextStartText + (this._series[i].Name.length * 6) + legendBoxWidth + (spaceInLegendContents * 2);
            }
        }
        legendContents = legendContents + '</g>';
        return legendContents;
    },

    drawAxisValues: function () {
        var axisContents = '';
        var textLength = 0;
        for (var i = 0; i < this.arrXAxisLength; i++) {
            textLength = (this.arrXAxis[i].toString().length * 10 * i / 10).toString().length * 5.5;
            axisContents = axisContents + String.format('<text id="SeriesAxis" x="{0}" y="{1}" fill-opacity="1">{2}</text>', Math.round(this.startX + (this.xInterval * 10 * i / 10) + (this.xInterval * 50 / 100) - textLength), this.startY + Math.round(this.yInterval * 65 / 100), this.arrXAxis[i]);
        }

        for (var i = 0; i <= this._valueAxisLines; i++) {
            textLength = (this.roundedTickRange * 10 * i / 10).toString().length * 5.5;
            axisContents = axisContents + String.format('<text id="ValueAxis" x="{0}" y="{1}">{2}</text>', this.startX - textLength -15, this.startY - (this.yInterval * 10 * i / 10) + 3.5, this.roundedTickRange * 10 * i / 10);
        }

        if (this.yMin < 0) {
            for (var i = 1; i <= this._valueAxisLines; i++) {
                textLength = (this.roundedTickRange * 10 * i / 10).toString().length * 5.5;
                axisContents = axisContents + String.format('<text id="ValueAxis" x="{0}" y="{1}">-{2}</text>', this.startX - textLength - 19, this.startY + (this.yInterval * 10 * i / 10), this.roundedTickRange * 10 * i / 10);
            }
        }

        return axisContents;
    },

    initializeSVG: function () {
        var svgContents = String.format('<?xml-stylesheet type="text/css" href="{0}.css"?>', this._theme);
        svgContents = svgContents + String.format('<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="{0}" height="{1}" style="position: relative; display: block;">', this._chartWidth, this._chartHeight);
        svgContents = svgContents + '<defs>';
        svgContents = svgContents + '<linearGradient gradientTransform="rotate(0)">';
        svgContents = svgContents + '<stop offset="0%" id="LinearGradient1"></stop>';
        svgContents = svgContents + '<stop offset="25%" id="LinearGradient2"></stop>';
        svgContents = svgContents + '<stop offset="100%" id="LinearGradient3"></stop></linearGradient>';
        svgContents = svgContents + '</defs>';

        svgContents = svgContents + String.format('<path fill="none" stroke-opacity="1" fill-opacity="1" stroke-linejoin="round" stroke-linecap="square" d="M5 {0} {1} {0} {1} {2} 5 {2} z"></path>', parseInt(this._chartHeight) * 1 / 10 + 5, parseInt(this._chartWidth) - 5, parseInt(this._chartHeight) - parseInt(this._chartHeight) * 1 / 10);
        svgContents = svgContents + String.format('<path id="ChartBackGround" stroke="" d="M0 0 {0} 0 {0} {1} 0 {1} z"></path>', this._chartWidth, this._chartHeight);
        svgContents = svgContents + String.format('<path fill="#ffffff" stroke-opacity="1" fill-opacity="0" stroke-linejoin="round" stroke-linecap="square" stroke="" d="M5 {0} {1} {0} {1} {2} 5 {2} z"></path>', parseInt(this._chartHeight) * 1 / 10 + 5, parseInt(this._chartWidth) - 5, parseInt(this._chartHeight) - parseInt(this._chartHeight) * 1 / 10);

        return svgContents;
    },

    drawAreas: function () {
        var areaContents = '';
        var yVal = new Array();
        var lastStartX = new Array();
        var lastStartY = new Array();

        var areaPath = new Array();



        for (var i = 0; i < this.arrXAxisLength; i++) {
            for (var j = 0; j < this._series.length; j++) {
                yVal[j] = 0;
                if (this._chartType == Sys.Extended.UI.AreaChartType.Stacked) {
                    for (var k = 0; k <= j; k++) {
                        yVal[j] = parseFloat(yVal[j]) + parseFloat(this._series[k].Data[i]);
                    }
                } else {
                    yVal[j] = parseFloat(this._series[j].Data[i]);
                }

                if (i == 0) {
                    areaPath[j] = String.format('{0} {1} {0} {2} ', this.startX + (this.xInterval / 2), this.startY, this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange)));
                }
                else if (i == this.arrXAxisLength - 1) {
                    areaPath[j] = areaPath[j] + String.format('{0} {1} {2} {3} {2} {4} ', lastStartX[j], lastStartY[j], this.startX + (this.xInterval * i) + (this.xInterval / 2), this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange)), this.startY);
                }
                else {
                    areaPath[j] = areaPath[j] + String.format('{0} {1} ', this.startX + (this.xInterval * i) + (this.xInterval / 2), this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange)));
                }

                if (yVal[j] > 0)
                    areaContents = areaContents + String.format('<text id="LegendText" x="{0}" y="{1}">{2}</text>', this.startX + (this.xInterval * i) + (this.xInterval * 50 / 100) - yVal[j].toString().length * this.charLength, this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange)) - 7.5, yVal[j]);
                else
                    areaContents = areaContents + String.format('<text id="LegendText" x="{0}" y="{1}">{2}</text>', this.startX + (this.xInterval * i) + (this.xInterval * 50 / 100) - yVal[j].toString().length * this.charLength, this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange)) + 7.5, yVal[j]);

                lastStartX[j] = this.startX + (this.xInterval * i) + (this.xInterval / 2);
                lastStartY[j] = this.startY - Math.round(yVal[j] * (this.yInterval / this.roundedTickRange));
            }
        }
        this._parentDiv.innerHTML = this._parentDiv.innerHTML + areaContents;
        var svgContentsBeforeAnimation = this._parentDiv.innerHTML;
        this.drawArea(this, areaPath, 0);

    },

    drawArea: function (me, areaPath, seriesIndex) {
        me._parentDiv.innerHTML = me._parentDiv.innerHTML.replace('</svg>', '') + String.format('<g><path id="AreaPath{1}" d="M{0} z" style="fill:{2};stroke:{2}"></path></g></svg>', areaPath[seriesIndex], seriesIndex + 1, me._series[seriesIndex].AreaColor);

        seriesIndex++;
        if (seriesIndex < me._series.length) {
            setTimeout(function () {
                me.drawArea(me, areaPath, seriesIndex);
            }, 400);
        }
    },








    get_chartWidth: function () {
        return this._chartWidth;
    },
    set_chartWidth: function (value) {
        this._chartWidth = value;
    },

    get_chartHeight: function () {
        return this._chartHeight;
    },
    set_chartHeight: function (value) {
        this._chartHeight = value;
    },

    get_chartTitle: function () {
        return this._chartTitle;
    },
    set_chartTitle: function (value) {
        this._chartTitle = value;
    },

    get_categoriesAxis: function () {
        return this._categoriesAxis;
    },
    set_categoriesAxis: function (value) {
        this._categoriesAxis = value;
    },

    get_ClientSeries: function () {
        return this._series;
    },
    set_ClientSeries: function (value) {
        this._series = value;
    },

    get_chartType: function () {
        return this._chartType;
    },
    set_chartType: function (value) {
        this._chartType = value;
    },

    get_theme: function () {
        return this._theme;
    },
    set_theme: function (value) {
        this._theme = value;
    },

    get_valueAxisLines: function () {
        return this._valueAxisLines;
    },
    set_valueAxisLines: function (value) {
        this._valueAxisLines = value;
    },

    get_chartTitleColor: function () {
        return this._chartTitleColor;
    },
    set_chartTitleColor: function (value) {
        this._chartTitleColor = value;
    },

    get_valueAxisLineColor: function () {
        return this._valueAxisLineColor;
    },
    set_valueAxisLineColor: function (value) {
        this._valueAxisLineColor = value;
    },

    get_categoryAxisLineColor: function () {
        return this._categoryAxisLineColor;
    },
    set_categoryAxisLineColor: function (value) {
        this._categoryAxisLineColor = value;
    },

    get_baseLineColor: function () {
        return this._baseLineColor;
    },
    set_baseLineColor: function (value) {
        this._baseLineColor = value;
    }
};

Sys.Extended.UI.AreaChart.registerClass("Sys.Extended.UI.AreaChart", Sys.Extended.UI.ControlBase);
Sys.registerComponent(Sys.Extended.UI.AreaChart, { name: 'AreaChart', parameters: [{ name: 'ClientSeries', type: 'AreaChartSeries[]'}] });

Sys.Extended.UI.AreaChartType = function () {
    /// <summary>
    /// Type of Area Chart
    /// </summary>            
    /// <field name="Basic" type="Number" integer="true" />
    /// <field name="Stacked" type="Number" integer="true" />
    throw Error.invalidOperation();
}
Sys.Extended.UI.AreaChartType.prototype = {
    Basic: 0,
    Stacked: 1
}

Sys.Extended.UI.AreaChartType.registerEnum("Sys.Extended.UI.AreaChartType", false);
