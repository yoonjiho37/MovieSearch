//
//  SerchResult.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/31.
//

import Foundation

struct SearchChannel: Codable {
    let Query: String
    let KMAQuery: String
    let TotalCount: Int
    let Data: [MovieInfoResult]
}
struct MovieInfoResult: Codable {
    let CollName: String
    let TotalCount: Int
    let Count: Int
    let Result: [MovieInfo]
}
struct MovieInfo: Codable {
    let DOCID: String
    let movieId: String  //등록ID    K
    let movieSeq: String  //  등록SEQ    04629
    let title: String  //영화명    서편제
    let titleEng: String  //영문제명
    let titleOrg: String  //원제명
    let titleEtc: String  //기타제명(제명 검색을 위해 관리되는 제명 모음)
    let prodYear: String  //제작년도    2011
    let directors: Directors
    let actors: Actors
    let nation: String  //제작국가    대한민국
    let company: String  //제작사    ㈜JK필름,CJ E&M Pictures
    let plots: Plots
    let runtime: String  //대표상영시간    112
    let rating: String  //대표관람등급    15세관람가
    let genre: String  //kmdbUrl    액션,SF
    let kmdbUrl: String  //링크URL    https://www.kmdb.or.kr/db/kor/detail/movie/K/18606
    let type: String  //유형구분    극영화
    let use: String  //용도구분    극장용
    let episodes: String  //영상 내 에피소드
    let ratedYn: String  //심의여부    Y
    let repRatDate: String  //대표심의일    2011-07-13
    let repRlsDate: String  //대표개봉일    2011-08-04
    let ratings: Ratings
    let keywords: String  //키워드    괴물,괴생물체,석유,심해,해저
    let posters: String  //포스터이미지URL    http://file.koreafilm.or.kr/thm/02/00/01/46/tn_DPK004440.JPG
    let stlls: String  //스틸이미지URL    http://file.koreafilm.or.kr/thm/01/copy/00/37/32/tn_DSKT155961.jpg
    let staffs: Staffs
    let vods: Vods
    let openThtr: String  //개봉극장
    let stat: [Stat]
    let screenArea: String  //관람지역
    let screenCnt: String  //스크린수
    let salesAcc: String  //누적매출액
    let audiAcc: String  //누적관람인원
    let statSouce: String  //출처
    let statDate: String  //기준일
    let themeSong: String  //주제곡
    let soundtrack: String  //삽입곡    "Blow out" 스윗리벤지
    let fLocation: String  //촬영장소
    let Awards1: String  //영화제수상내역
    let Awards2: String  //수상내역 기타
    let regDate: String  //등록일    2010-12-20
    let modDate: String  //최종수정일    2016-02-16
    let Codes: Codes
    let CommCodes: CommCodes
    let ALIAS: String
}


struct Directors: Codable {
    let director: [Director]
    struct Director: Codable {
        let directorNm: String  //감독명    김지훈
        let directorEnNm: String  //감독명(영문)    Kim Ji Hoon
        let directorId: String  //감독등록번호    00044214
    }
}
struct Actors: Codable {
    let actor: [Actor]
    struct Actor: Codable {
        let actorNm: String  //배우명    하지원
        let actorEnNm: String  //배우명(영문)    Ha Ji-won
        let actorId: String  //배우등록번호    00004417
    }
}
struct Plots: Codable {
    let plot: [Plot]
    struct Plot: Codable {
        let plotLang: String  //제작년도    2011
        let plotText: String  //줄거리    제주도 남단, 7광구의.....
    }
}
struct Ratings: Codable {
    let rating: [Rating]
    struct Rating: Codable {
        let ratingMain: String  //대표심의정보 여부    Y
        let ratingDate: String  //심의일    2011-07-13
        let ratingNo: String  //심의번호    2011-F363
        let ratingGrade: String  //관람기준    15세관람가
        let releaseDate: String  //개봉일자    2011-08-04
        let runtime: String  //상영시간    112
    }
}
struct Staffs: Codable {
    let staff: [Staff]
    struct Staff: Codable {
        let staffNm: String  //스텝이름    하지원
        let staffEnNm: String  //스텝 영어이름
        let staffRoleGroup: String  //스텝크레딧명    출연
        let staffRole: String  //스텝배역    차해준
        let staffEtc: String  //스텝기타
        let staffId: String  //스텝등록번호    00004417
    }
}
struct Vods: Codable {
    let vod: [Vod]
    struct Vod: Codable {
        let vodClass: String  //VOD 구분    티저 예고편
        let vodUrl: String  //VOD URL    http://www.kmdb.or.kr/vod/vod_basic.asp?nation=K&p_dataid=12599&pgGubun=04
    }
}
struct Stat: Codable {
    let screenArea: String  //관람지역
    let screenCnt: String  //스크린수
    let salesAcc: String  //누적매출액
    let audiAcc: String  //누적관람인원
    let statSouce: String  //출처
    let statDate: String  //기준일
}
struct Codes: Codable {
    let Code: [Code]
    struct Code: Codable {
        let CodeNm: String  //외부코드명    FIMS
        let CodeNo: String  //외부코드    20182530
    }
}
struct CommCodes: Codable {
    let CommCode: [CommCode]
    struct CommCode: Codable {
        let CodeNm: String  //외부코드명    FIMS
        let CodeNo: String  //외부코드    20182530
    }
}
