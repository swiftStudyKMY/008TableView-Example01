//
//  ListViewController.swift
//  008TableView-Example01
//
//  Created by 김민영 on 11/21/19.
//  Copyright © 2019 김민영. All rights reserved.
//

import Foundation
import UIKit

class ListViewController:UITableViewController{
    
//    var list = [MovieVO]( );
    
    var dataset = [
        ("다크나이트1","영웅 다크나이트 영웅 다크나이트1","1989-04-03",7.75),
        ("다크나이트2","영웅 다크나이트 영웅 다크나이트2","1989-04-04",7.76),
        ("다크나이트3","영웅 다크나이트 영웅 다크나이트3","1989-04-05",7.77)
    ]
    
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        
        for (title,desc,opendate,rating) in self.dataset{
            let mvo = MovieVO()
            
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            
            datalist.append(mvo)
        }
        
        return datalist
        
    }()
    
//MARK:생성할 목록의 길이 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberOfRowsInSection call : \(self.list.count)")
        return self.list.count
    }
//MARK:셀 객체를 생성하여 콘텐츠를 구성한 다음 반환
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("cellForRowAt call")
        let row = self.list[indexPath.row]
        
        // return value type [UITableViewCell?]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        
        cell.textLabel?.text = row.title
        
        return cell
    }
//MARK:사용자가 셀 선택시 콜백
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("didSelectRowAt call")
        NSLog("select row is \(indexPath.row) 번째 행입니다.") 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad call")

//        하드코딩으로 인한 주석처리
//        var mvo = MovieVO( )
//        mvo.title = "다크나이트1"
//        mvo.description = "영웅 다크나이트 영웅 다크나이트1"
//        mvo.opendate = "1989-04-03"
//        mvo.rating = 7.39
//
//        self.list.append(mvo)
//
//        mvo = MovieVO( )
//        mvo.title = "다크나이트2"
//        mvo.description = "영웅 다크나이트 영웅 다크나이트2"
//        mvo.opendate = "1989-04-04"
//        mvo.rating = 7.38
//
//        self.list.append(mvo)
//
//        mvo = MovieVO( )
//        mvo.title = "다크나이트3"
//        mvo.description = "영웅 다크나이트 영웅 다크나이트3"
//        mvo.opendate = "1989-04-05"
//        mvo.rating = 7.40
//
//        self.list.append(mvo)
        
    }
    
}
