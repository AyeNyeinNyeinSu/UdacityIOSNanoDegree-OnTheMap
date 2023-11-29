//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Aye Nyein Nyein Su on 20/05/2023.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    var studentsLoc = StudentsData.sharedInstance().students

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsLists()
    }

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getStudentsLists()
    }

    func getStudentsLists() {
        
        UdacityClient.getStudentLocations() { results, error in
            if error != nil {
                self.showAlert(message: error!.localizedDescription, title: "Invalid Student Locations Temporarily")
            } else {
                self.studentsLoc = results!
                self.tableView.reloadData()
            }
        }
    }

// MARK: - TableView Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLoc.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocTableViewCell", for: indexPath)
        let student = studentsLoc[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentsLoc[indexPath.row]
        guard let url = URL(string: student.mediaURL) else { return }
        UIApplication.shared.openURL(url)
    }

    
}
