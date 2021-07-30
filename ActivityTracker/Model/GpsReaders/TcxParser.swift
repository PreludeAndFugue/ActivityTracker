//
//  TcxParser.swift
//  ActivityTracker
//
//  Created by gary on 30/07/2021.
//

import Foundation

final class TcxParser: NSObject {
    enum Element: String {
        case trackPoint = "Trackpoint"
        case time = "Time"
        case lat = "LatitudeDegrees"
        case lng = "LongitudeDegrees"
        case altitude = "AltitudeMeters"
        case distance = "DistanceMeters"
    }

    struct Point {
        var time: String = ""
        var lat: Double = 0
        var lng: Double = 0
        var altitude: Double = 0
        var distance: Double = 0

        var validated: Point? {
            if time == "" || lat == 0 || lng == 0 {
                return nil
            } else {
                return self
            }
        }
    }


    let url: URL
    var element: Element?
    var point: Point?
    var points: [Point] = []


    init(url: URL) {
        self.url = url
        super.init()
    }


    func parse() -> [Point] {
        let data = removeWhiteSpace(url: url)
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return points.compactMap({ $0.validated })
    }
}


// MARK: - XMLParserDelegate

extension TcxParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = Element(rawValue: elementName)
        switch element {
        case .trackPoint:
            point = Point()
        case .time, .lat, .lng, .altitude, .distance:
            break
        case .none:
            break
        }
    }


    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch Element(rawValue: elementName) {
        case .trackPoint:
            if let point = point {
                points.append(point)
            }
        default:
            break
        }
        element = nil
    }


    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch element {
        case .trackPoint:
            break
        case .time:
            point?.time = string
        case .lat:
            point?.lat = Double(string) ?? 0.0
        case .lng:
            point?.lng = Double(string) ?? 0.0
        case .altitude:
            point?.altitude = Double(string) ?? 0.0
        case .distance:
            point?.distance = Double(string) ?? 0.0
        case .none:
            break
        }
    }


    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("error")
        print(parseError)
        print(parser.lineNumber)
        print(parser.columnNumber)
    }
}


// MARK: - Private

private extension TcxParser {
    func removeWhiteSpace(url: URL) -> Data {
        let string = try! String(contentsOf: url, encoding: .utf8)
        if string.starts(with: " ") {
            return string.trimmingCharacters(in: .whitespaces)
                .data(using: .utf8)!
        } else {
            return string.data(using: .utf8)!
        }
    }
}
