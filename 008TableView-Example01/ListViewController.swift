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
            
            for row in movie{
                let r  = row as! NSDictionary
                
                let mvo = MovieVO()
             
             mvo.title       = r["title"] as? String
             mvo.description = r["genreNames"] as? String
             mvo.thumbnail   = r["thumbnailImage"] as? String
             mvo.detail      = r["linkUrl"] as? String
             mvo.rating      = (r["ratingAverage"] as! NSString).doubleValue
             
             self.list.append(mvo)
             
            }
            
        }catch{}
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
        
        // return value type [UITableViewCell?]
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!

        /*
            Basic 및 subtitle
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.text = row.description
        */
        
        /*
            CustomCell
            //1. viewWithTag tag 값을 참조하여 UIView 객체 값을 가져오기
            //2. UIview 객체로 가져와서 UILabel로 downCast
            //3. ?(optional)을 통해 입력되지 않을 태그값을 호출하는 경우 대비
            let title = cell.viewWithTag(101) as? UILabel
            let desc = cell.viewWithTag(102) as? UILabel
            let opendate = cell.viewWithTag(103) as? UILabel
            let rating = cell.viewWithTag(104) as? UILabel
            
            
            title?.text = row.title
            desc?.text = row.description
            opendate?.text = row.opendate
            rating?.text = "\(row.rating!)"
        */
        
        //UITableViewCell(MovieCell.swift)을 이용한 ListCell 할당
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
               
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
//        cell.thumbnail.image = UIImage(named: row.thumbnail!)
        
        //1. thumbnail 경로를 URL 객체로 생성
        let url : URL! = URL(string: row.thumbnail!)
        //2. img를 Data로 저장
        let imgData = try! Data(contentsOf: url)
        //3. UIImage에 대입
        cell.thumbnail.image = UIImage(data:imgData)
        //4. 한줄처리
        //cell.thumbnail.image = UIImage(data:try! Data(contentsOf: URL(string: row.thumbnail!)!))
        
        
        return cell
    }
//MARK:사용자가 셀 선택시 콜백
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("didSelectRowAt call")
        NSLog("select row is \(indexPath.row) 번째 행입니다.") 
    }
}
