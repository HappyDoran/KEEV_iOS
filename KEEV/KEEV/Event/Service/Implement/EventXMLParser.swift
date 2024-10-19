//
//  EventXMLParser.swift
//  KEEV
//
//  Created by Doran on 10/18/24.
//

import Foundation

/// XML 형식의 데이터를 파싱하고 뷰에 나타내기 위한 메소드가 구현된 클래스
///
/// `XMLParser`가 파싱된 문서의 내용에 대해 대리자에게 알리는 `XMLParserDelegate` 프로토콜을 채택하여 다양한 XML 처리 관련 기능들을 제공합니다.
///
/// - Author: Doran
class EventXMLParser: NSObject, XMLParserDelegate {
    // MARK: 현재 XML 문서들을 읽을 때 현재 읽고 있는 필드들과 반환할 리스트를 담을 변수 선언
    private var events: [ConcertDTO] = []
    private var currentElement = ""
    private var currentID = ""
    private var currentTitle = ""
    private var currentStartDate = ""
    private var currentEndDate = ""
    private var currentPlace = ""
    private var currentPoster = ""
    /// XML 데이터를 파싱하여 ConcertDTO 배열로 반환하는 메소드.
    ///
    /// - Parameter data: 파싱할 XML 형식의 데이터.
    ///
    /// - Returns: 파싱된 공연 정보를 담고 있는 `ConcertDTO` 배열.
    ///
    /// - Author: Doran
    func parse(_ data: Data) -> [ConcertDTO] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return events
    }
    
    // MARK: XMLParserDelegate
    /// XML 요소의 시작을 알리는 메소드.
    ///
    /// - Parameters:
    ///   - parser: 현재 XML 파서 인스턴스.
    ///   - elementName: 시작한 XML 요소의 이름.
    ///   - namespaceURI: 요소의 네임스페이스 URI.
    ///   - qualifiedName: 자격이 있는 이름.
    ///   - attributeDict: 요소의 속성.
    ///
    /// - Author: Doran
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]
    ){
        currentElement = elementName
        
        if currentElement == "db" {
            currentID = ""
            currentTitle = ""
            currentStartDate = ""
            currentEndDate = ""
            currentPlace = ""
            currentPoster = ""
        }
    }
    
    /// XML 요소의 문자 데이터를 발견했을 때 호출되는 메소드.
    ///
    /// - Parameters:
    ///   - parser: 현재 XML 파서 인스턴스.
    ///   - string: 발견된 문자 데이터.
    ///
    /// - Author: Doran
    func parser(_ parser: XMLParser, foundCharacters string: String){
        switch currentElement {
        case ConcertDTO.CodingKeys.id.rawValue:
            currentID += string
        case ConcertDTO.CodingKeys.title.rawValue:
            currentTitle += string
        case ConcertDTO.CodingKeys.startDate.rawValue:
            currentStartDate += string
        case ConcertDTO.CodingKeys.endDate.rawValue:
            currentEndDate += string
        case ConcertDTO.CodingKeys.place.rawValue:
            currentPlace += string
        case ConcertDTO.CodingKeys.poster.rawValue:
            currentPoster += string
        default:
            break
        }
    }
    
    /// XML 요소의 끝을 알리는 메소드.
    ///
    /// - Parameters:
    ///   - parser: 현재 XML 파서 인스턴스.
    ///   - elementName: 종료된 XML 요소의 이름.
    ///   - namespaceURI: 요소의 네임스페이스 URI.
    ///   - qualifiedName: 자격이 있는 이름.
    ///
    /// - Author: Doran
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if elementName == "db" {
            let event = ConcertDTO(id: currentID, title: currentTitle, startDate: currentStartDate, endDate: currentEndDate, place: currentPlace, poster: currentPoster)
            events.append(event)
        }
    }
}
