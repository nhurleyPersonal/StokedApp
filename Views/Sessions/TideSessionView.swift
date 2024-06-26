import SwiftUI
import SwiftUICharts

struct TideSessionView: View {
    var tideData: TideData
    var startDate: Date?
    var endDate: Date?
    var tideTimes: [Date] {
        tideData.tideData.map { entry in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.date(from: entry.time) ?? Date()
        }
    }

    var tideHeights: [Double] {
        tideData.tideData.map { entry in
            Double(entry.value) ?? 0
        }
    }

    @State var data: LineChartData = .init(dataSets: LineDataSet(dataPoints: []))

    var body: some View {
        VStack {
            FilledLineChart(chartData: data)
                .touchOverlay(chartData: data, specifier: "%.1f", unit: .suffix(of: "ft"))
                .xAxisGrid(chartData: data)
                .xAxisLabels(chartData: data)
                .infoBox(chartData: data)
                .id(data.id)
                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                .onAppear {
                    data = tideDataToLineChartData()
                }
        }
    }

    func tideDataToLineChartData() -> LineChartData {
        var dataPoints = zip(tideTimes, tideHeights).map { time, height -> LineChartDataPoint in
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm"
            let label = formatter.string(from: time)
            return LineChartDataPoint(value: height, xAxisLabel: label, description: label)
        }

        // Find local minima and maxima
        var previousSlope: Double? = nil
        for i in 1 ..< dataPoints.count - 1 {
            let slope = dataPoints[i].value - dataPoints[i - 1].value
            if let previousSlope = previousSlope, previousSlope * slope < 0 {
                // Slope has changed sign, so we have a local minimum or maximum
                let point = dataPoints[i]
                let newPoint = LineChartDataPoint(value: point.value, xAxisLabel: point.xAxisLabel, description: point.description, pointColour: PointColour(border: .red))
                dataPoints[i] = newPoint
            }
            previousSlope = slope
        }

        let dataSet = LineDataSet(dataPoints: dataPoints,
                                  legendTitle: "Tide Heights",
                                  pointStyle: PointStyle(),
                                  style: LineStyle(lineColour: ColourStyle(colours: [Color.green.opacity(0.90),
                                                                                     Color.green.opacity(0.40)],
                                                                           startPoint: .top,
                                                                           endPoint: .bottom),
                                                   lineType: .line))

        let nth = 40 // Change this to control the frequency of the labels
        let xAxisLabels = tideTimes.enumerated().compactMap { index, time in
            index % nth == 0 ? DateFormatter.localizedString(from: time, dateStyle: .none, timeStyle: .short) : nil
        }

        let gridStyle = GridStyle(numberOfLines: xAxisLabels.count,
                                  lineColour: Color(.lightGray).opacity(0.50))

        return LineChartData(dataSets: dataSet,
                             xAxisLabels: xAxisLabels,
                             chartStyle: LineChartStyle(infoBoxPlacement: .infoBox(isStatic: false),
                                                        markerType: .full(attachment: .point),
                                                        xAxisGridStyle: gridStyle, xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                        globalAnimation: .default))
    }
}
