//
//  ViewController.swift
//  Workout Timer
//
//  Created by user153727 on 4/20/19.
//  Copyright © 2019 Devvers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets?
    var timer: Timer!
    
    var intervalTime = 0
    
    var tempIntervalCount = 0
    
    var tempRestCount = 0
    
    var restIsActive = false
    
    var totalTime = 0
    
    private let dataSource = ["10", "20", "30", "40", "50"]
   
    
    @IBOutlet weak var restLabel: UILabel!
    
    @IBOutlet weak var goLabel: UILabel!
    
    @IBOutlet weak var staticTimeLabel: UILabel!
    
    @IBOutlet weak var staticIntervalLabel: UILabel!
    
    @IBOutlet weak var staticSecondsLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var timerChangeButton: UIButton!
    
    @IBOutlet weak var intervalChangeButton: UIButton!
    
    @IBOutlet weak var startTimerButton: UIButton!
    
    @IBOutlet weak var choiceDoneButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var timerPicker: UIDatePicker!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        intervalPicker.dataSource = self
        intervalPicker.delegate = self
        
}
    
    //MARK: Actions
    
    
    
    
    /* function: timeChangeAction
     *
     *  Description: Allows user to start the process of setting the "Time" from date picker of selections. Generally will just cause different buttons to become hidden/non-hidden
     */
    @IBAction func timeChangeAction(_ sender: UIButton) {
        
        timerChangeButton.isHidden = true
        
        intervalChangeButton.isEnabled = false
        
        timerPicker.isHidden = false
        
        startTimerButton.isHidden = true
        
        choiceDoneButton.isHidden = false
}
    
    
    
    /* funciton: intervalChangeAction
     *
     * Description: Allows user to start the process of setting the intervals of the timer. Will just change hidden status of some buttons and datePicker.
     */
    @IBAction func intervalChangeAction(_ sender: UIButton) {
        
        intervalChangeButton.isHidden = true
        
        timerChangeButton.isEnabled = false
        
        choiceDoneButton.isHidden = false

        startTimerButton.isHidden = true
        
        intervalPicker.isHidden = false
}
    
    
    
    
    /* function: timeChangeActionFinish
     *
     * Description: Finishes the time choosing process. Will take selection from user's datepicker choice, then update the time label with the user's choice. Will change buttons and datePickers hidden status.
     */
    @IBAction func timeChangeActionFinish(_ sender: Any) {
        
        
        if(timerChangeButton.isHidden == true){
            let dateFormatter =  DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeChosen = dateFormatter.string(from: timerPicker.date)
            TimeLabel.text = timeChosen
            
            timerPicker.isHidden = true
            
            choiceDoneButton.isHidden = true
            
            timerChangeButton.isHidden = false
            
            intervalChangeButton.isEnabled = true
            
            startTimerButton.isHidden = false
            
            
        }
            
        else{
            
            timerChangeButton.isEnabled = true
            
            intervalPicker.isHidden = true
            
            intervalChangeButton.isHidden = false
            
            choiceDoneButton.isHidden = true
            
            if(TimeLabel.text == "00:00"){
                startTimerButton.isHidden = true
            }
            else{
                startTimerButton.isHidden = false
            }
            
            
    }
}
    
    
    /* function: startTimerAction
     *
     * Description: This function will be called once the "Start Timer" button has been pressed. It will animate the labels off the screen. then it will call another function to start the timer.
     */
    @IBAction func startTimerAction(_ sender: UIButton) {
        
        intervalChangeButton.isHidden = true
        timerChangeButton.isHidden = true
        startTimerButton.isHidden = true
        
        pauseButton.isHidden = false
        cancelButton.isHidden = false
        pauseButton.center.x -= 300
        cancelButton.center.x += 300
        
        UIView.animate(withDuration: 2.5, animations:
            {
                self.staticTimeLabel.center.x -= 300
            
                self.staticIntervalLabel.center.x -= 300
            
                self.staticSecondsLabel.center.x += 300
            
                self.intervalLabel.center.x += 300
                
                self.pauseButton.center.x += 300
                
                self.cancelButton.center.x -= 300
                
                self.TimeLabel.text?.append(":00")
                
                self.TimeLabel.center.y += 150
                
                self.TimeLabel.center.x -= 25

                
                self.TimeLabel.transform = CGAffineTransform(scaleX: 2, y: 2)

        })
        
        runTimer()
    
}
    
    
    /* function: runTimer
     *
     * Description: This function is called by startTimerAction, which is caused by the press of "Start Timer". Once run, this function will get each of the times set and run the timer.
     */
    func runTimer(){
        
        goLabel.isHidden = false
        
        let hours = Int(TimeLabel.text!.components(separatedBy: ":")[0])!
        let minutes = Int(TimeLabel.text!.components(separatedBy: ":")[1])!
       
        totalTime = (hours*3600)+(minutes*60)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
    
}
    
    
    /* function: updateTimer
     *
     * Description: This funciton will be called by the timer in the runTimer function. It will continuously be called by the timer untill stopped, or the time runes out.
     *
     * added 4/22/19: This function will also be used to keep track of the user's interval times.
     */
    @objc func updateTimer(){
        if(totalTime < 1){
            timer.invalidate()
        }
        else{
            
            totalTime -= 1
            
            if(restIsActive == true){
                if(tempRestCount == 0){
                    restLabel.isHidden = true
                    goLabel.isHidden = false
                    restIsActive = false
                }
                else{
                goLabel.isHidden = true
                restLabel.isHidden = false
                tempRestCount -= 1
                }
            }
            else{
            tempIntervalCount += 1
            }
           
            if(tempIntervalCount == 60-intervalTime){
                restIsActive = true
                tempRestCount = intervalTime
                tempIntervalCount = 0
            }
            
            let hours = totalTime/3600
            let minutes = (totalTime/60)%60
            let seconds = totalTime%60
            
          
            if(hours < 10){
                TimeLabel.text = "0\(hours):"
            }
            else{
                TimeLabel.text = "\(hours):"
            }
            if(minutes < 10){
                TimeLabel.text?.append("0\(minutes):")
            }
            else{
                TimeLabel.text?.append("\(minutes):")
            }
            if(seconds < 10){
                TimeLabel.text?.append("0\(seconds)")
            }
            else{
                TimeLabel.text?.append("\(seconds)")
            }
        }
    }
    /* function: pauseButtonAction
     *
     * Description: This function will be called when the 'pause' button is pressed by the user. The function will then stop the timer where it currently is. It will also change the hidden statiu
     */
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        timer.invalidate()
        pauseButton.isHidden = true
        resumeButton.isHidden = false
    }
    
    
    /* fucntion: resumeButtonAction
     *
     * Description: This function will be called when the 'resume button is pressed by the user. The funciton will resume the timers, then change the hidden status of the 'pause' and 'resume' buttons
     */
    @IBAction func resumeButtonAction(_ sender: UIButton) {
        timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        resumeButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    /* function: cancelButtonAction
     *
     * Description: This function will be called by the 'cancel' button. It will return to the original screen where the user may interact with the time changing buttons.
     */
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        goLabel.isHidden = true
        restLabel.isHidden = true
        
        timer.invalidate()
        
        TimeLabel.text = "00:00"
        
        UIView.animate(withDuration: 2.5, animations: {
            
                
            self.TimeLabel.center.y -= 150
            
            self.TimeLabel.center.x += 25
                
            self.TimeLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            self.pauseButton.center.x -= 300
                
            self.resumeButton.center.x -= 300
                
            self.cancelButton.center.x += 300
                
            self.staticTimeLabel.center.x += 300
                
            self.staticSecondsLabel.center.x -= 300
                
            self.staticIntervalLabel.center.x += 300
                
            self.intervalLabel.center.x -= 300
                
          
            
            
            })
        
            /* This code delays the reappearance of the change buttons
             * and hides the pause/resume/cancel buttons, and returns them
             * to where they should be.
             */
            DispatchQueue.main.asyncAfter(deadline: .now() +  3.0,  execute:{
            self.resumeButton.isHidden = true
        
            self.resumeButton.center.x += 300
        
            self.pauseButton.isHidden = true
        
            self.pauseButton.center.x += 300
        
            self.cancelButton.isHidden = true
        
            self.cancelButton.center.x -= 300
        
            self.timerChangeButton.isHidden = false
        
            self.intervalChangeButton.isHidden = false
        
        })
    }
}




    
    /* This ViewController extension is for the
     * UIPicker.
     */
    extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataSource.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dataSource[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            intervalLabel.text = dataSource[row]
            intervalTime = Int(dataSource[row])!
        }
        
        
}


