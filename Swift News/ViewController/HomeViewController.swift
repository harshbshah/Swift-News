//
//  ViewController.swift
//  Swift News
//
//  Created by Harsh_Dev on 2020-06-14.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import UIKit
let imageCache = NSCache<NSString, UIImage>()

class HomeViewController: UIViewController {
    @IBOutlet weak var newsListTable: UITableView!
    let refreshControl = UIRefreshControl()
    
    var newsFeedModels:[NewsFeedModel]?
    {
        didSet
        {
//            self.newsListTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Swift News"
        setupUI()
        getDataFromServer()
        
        // Do any additional setup after loading the view.
    }


}

extension HomeViewController{
func getDataFromServer()
{
    API.callAPI(ApiMethod: .get, forURL: URLMangement.listNewsTopics, parameters: nil, completion: {
        
        (success, data,error) in
        DispatchQueue.main.async {
            if !success || data == nil || error != nil{
                //show error popup
            }
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
                self.newsListTable.contentOffset = CGPoint.zero
            }
            guard let responseRawDataString = String(data: data as! Data, encoding: .utf8)
            else
            {
                return
            }
            guard let responseDataDict = responseRawDataString.convertToDictionary()
                else{
                    return
            }
            guard let responseData = responseDataDict["data"] as? [String:Any] else{
              return
            }
            if let arrayJson = responseData["children"] as? [Dictionary<String,Any>]
            {
            self.newsFeedModels = arrayJson.compactMap { (objJson) -> NewsFeedModel in
              return NewsFeedModel.init(jsonData: objJson)
            }
                self.newsListTable.reloadData()
            }
            else{
                let alertView = UIAlertController.init(title: "Sorry", message: error ?? "Failed to fetch data from server.", preferredStyle: .alert)
                         alertView.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                         self.navigationController?.present(alertView, animated: true, completion: nil)
            }
        }
        
    })
}

func setupUI()
{
    newsListTable.delegate = self
    newsListTable.dataSource = self
    newsListTable.register(UINib.init(nibName: StoryBoardID.CellID.mainPageNewsCell, bundle: nil), forCellReuseIdentifier: StoryBoardID.CellID.mainPageNewsCell)
    setupTableViewUI()
}
    
}

//MARK: Pull to referesh
extension HomeViewController{
  func activatePullTorefresh(){
    refreshControl.addTarget(self, action: #selector(refreshContaint) , for: .valueChanged)
    newsListTable.refreshControl = refreshControl
  }
  @objc func refreshContaint(){
    getDataFromServer()
  }
}

//MARK: UITableview delegates

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
      func setupTableViewUI(){
        self.newsListTable.estimatedRowHeight = 150
        self.newsListTable.rowHeight = UITableView.automaticDimension
        newsListTable.tableFooterView = UIView()
        activatePullTorefresh()
      }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeedModels?.count ?? 0

      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 4
    }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoardID.CellID.mainPageNewsCell) as? MainPageNewsCell
         else{
          return UITableViewCell()
        }
        if(newsFeedModels?.count ?? 0 > indexPath.row)
        {
            cell.awakeFromNib()
            cell.singleNewsObject = newsFeedModels?[indexPath.row]
            
        }
        return cell
      }
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MainPageNewsCell else {
          return
        }
        cell.setNeedsDisplay()
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //redirect to the details page
        guard let detailViewControler = storyboard?.instantiateViewController(withIdentifier: StoryBoardID.detailViewController) as? DetailViewController else {
          return
        }
        let cell = tableView.cellForRow(at: indexPath) as! MainPageNewsCell
        detailViewControler.newsFeedModel = cell.singleNewsObject
        self.navigationController?.pushViewController(detailViewControler, animated: true)
      }
    }


