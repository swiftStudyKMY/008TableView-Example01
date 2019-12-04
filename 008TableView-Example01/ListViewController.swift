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

    var page = 1

    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        return datalist
        
    }()
    @IBOutlet var moreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad call")
        self.callAPI()
    }
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        
        self.callAPI()
        
        self.tableView.reloadData()
        
    }

    func callAPI() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        
        let apiURI :URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data:apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다."
        NSLog("API Res = \(log)")
        do {
         //json객체를 파싱하고 NSDictionary로 변환
            let apiDic = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDic["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            let totCnt = (hoppin["totalCount"] as? NSString)!.intValue
            
            for row in movie{
                let r  = row as! NSDictionary
                
                let mvo = MovieVO()
             
             mvo.title       = r["title"] as? String
             mvo.description = r["genreNames"] as? String
             mvo.thumbnail   = r["thumbnailImage"] as? String
             mvo.detail      = r["linkUrl"] as? String
             mvo.rating      = (r["ratingAverage"] as! NSString).doubleValue
             
                let url :URL! = URL(string: mvo.thumbnail!)
                let imgData = try! Data(contentsOf: url)
                mvo.thumbnailImg = UIImage(data:imgData)
                
             self.list.append(mvo)
                
                if(self.list.count >= totCnt){
                    self.moreBtn.isHidden = true
                }
             
            }
            
        }catch{}
    }
    //이미지 가져오는 소스 모듈화
    func getThumnailImg(_ index: Int) -> UIImage {
        let mvo = self.list[index]
        
        if let savedImg = mvo.thumbnailImg{
             return savedImg
        }else{
            let url: URL! = URL(string: mvo.thumbnail!)
            let imgData = try! Data(contentsOf: url)
            mvo.thumbnailImg = UIImage(data: imgData)
            
            return mvo.thumbnailImg!
        }
    }
    
//MARK:생성할 목록의 길이 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberOfRowsInSection call : \(self.list.count)")
        return self.list.count
    }
//MARK:셀 객체를 생성하여 콘텐츠를 구성한 다음 반환
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("cellForRowAt call")
        let row = self.list[indexPath.row]
        NSLog("호출된 행번호 : \(indexPath.row), 제목:\(row.title!)")
        
        //UITableViewCell(MovieCell.swift)을 이용한 ListCell 할당
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
               
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        //비동기로 이미지 가져오기 처리
        DispatchQueue.main.async(execute: {
            NSLog("비동기 방식으로 실행")
            cell.thumbnail.image = self.getThumnailImg(indexPath.row)
        })
        
        NSLog("메소드 실행을 종료 셀을 리턴")
        
        return cell
    }
//MARK:사용자가 셀 선택시 콜백
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("didSelectRowAt call")
        NSLog("select row is \(indexPath.row) 번째 행입니다.") 
    }
}
