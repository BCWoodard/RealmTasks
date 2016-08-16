//
//  TasksListsViewController.swift
//  RealmTasks
//
//  Created by Brad Woodard on 8/16/16.
//  Copyright © 2016 Brad Woodard. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var taskListsTableView: UITableView!

    var lists: Results<TaskList>!
    var isEditingMode = false
    var currentCreateAction: UIAlertAction!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        readTasksAndUpdateUI()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are tasks, display that number of rows
        if let tasksList = lists {
            return tasksList.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")!
        
        let taskList = lists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = "\(taskList.tasks.count) Tasks"
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { (deleteAction, indexPath) in
            let listToBeDeleted = self.lists[indexPath.row]
            try! uiRealm.write({ 
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            })
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (editAction, indexPath) in
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayAlertToAddTaskList(listToBeUpdated)
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("openTasks", sender: self.lists[indexPath.row])
    }
    
    //MARK: - IBActions
    @IBAction func editTasksList(sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.taskListsTableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addTaskList(sender: UIBarButtonItem) {
        //print("Add Item")
        displayAlertToAddTaskList(nil)
    }
    
    //MARK: - Utility functions
    func readTasksAndUpdateUI() {
        lists = uiRealm.objects(TaskList)
        self.taskListsTableView.setEditing(false, animated: true)
        self.taskListsTableView.reloadData()
    }
    
    func displayAlertToAddTaskList(updatedList:TaskList!) {
        var title = "New Task List"
        var doneTitle = "Create"
        if updatedList != nil {
            title = "Update Task List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Enter the name of your task list.", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil {
                // update mode
                try! uiRealm.write {
                    updatedList.name = listName!
                    self.readTasksAndUpdateUI()
                }
            } else {
                let newTaskList = TaskList()
                newTaskList.name = listName!
                
                try! uiRealm.write {
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
                }
            }
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(TasksListsViewController.listNameFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func listNameFieldDidChange(textField: UITextField) {
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedList = sender as! TaskList
    }
    
    //MARK: - Cleanup
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}