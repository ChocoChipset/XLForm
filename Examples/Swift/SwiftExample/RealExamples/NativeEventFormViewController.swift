//
//  NativeEventNavigationViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


class NativeEventFormViewController : XLFormViewController {



    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }


    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor

        
        form = XLFormDescriptor(title: "Add Event")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: "title", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Title"
        row.required = true
        section.addFormRow(row)
        
        // Location
        row = XLFormRowDescriptor(tag: "location", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Location"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // All-day
        row = XLFormRowDescriptor(tag: "all-day", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "All-day")
        section.addFormRow(row)
        
        // Starts
        row = XLFormRowDescriptor(tag: "starts", rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Starts")
        row.value = NSDate(timeIntervalSinceNow: 60*60*24)
        section.addFormRow(row)
        
        // Ends
        row = XLFormRowDescriptor(tag: "ends", rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Ends")
        row.value = NSDate(timeIntervalSinceNow: 60*60*25)
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Repeat
        row = XLFormRowDescriptor(tag: "repeat", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Repeat")
        row.value = XLFormOptionsObject(value: 0, displayText: "Never")
        row.selectorTitle = "Repeat"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText: "Never"),
                               XLFormOptionsObject(value: 1, displayText: "Every Day"),
                               XLFormOptionsObject(value: 2, displayText: "Every Week"),
                               XLFormOptionsObject(value: 3, displayText: "Every 2 Weeks"),
                               XLFormOptionsObject(value: 4, displayText: "Every Month"),
                               XLFormOptionsObject(value: 5, displayText: "Every Year")]
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Alert
        row = XLFormRowDescriptor(tag: "alert", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Alert")
        row.value = XLFormOptionsObject(value: 0, displayText: "None")
        row.selectorTitle = "Event Alert"
        row.selectorOptions = [
            XLFormOptionsObject(value: 0, displayText: "None"),
            XLFormOptionsObject(value: 1, displayText: "At time of event"),
            XLFormOptionsObject(value: 2, displayText: "5 minutes before"),
            XLFormOptionsObject(value: 3, displayText: "15 minutes before"),
            XLFormOptionsObject(value: 4, displayText: "30 minutes before"),
            XLFormOptionsObject(value: 5, displayText: "1 hour before"),
            XLFormOptionsObject(value: 6, displayText: "2 hours before"),
            XLFormOptionsObject(value: 7, displayText: "1 day before"),
            XLFormOptionsObject(value: 8, displayText: "2 days before")]
        section.addFormRow(row)


        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Show As
        row = XLFormRowDescriptor(tag: "showAs", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Show As")
        row.value = XLFormOptionsObject(value: 0, displayText: "Busy")
        row.selectorTitle = "Show As"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText:"Busy"),
                              XLFormOptionsObject(value: 1, displayText:"Free")]
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // URL
        row = XLFormRowDescriptor(tag: "url", rowType:XLFormRowDescriptorTypeURL)
        row.cellConfigAtConfigure["textField.placeholder"] = "URL"
        section.addFormRow(row)
        
        // Notes
        row = XLFormRowDescriptor(tag: "notes", rowType:XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "Notes"
        section.addFormRow(row)
        
        self.form = form
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelPressed:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
    }

// MARK: XLFormDescriptorDelegate

    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == "alert" {
            if !formRow.value!.valueData().isEqual(0) && oldValue.valueData().isEqual(0) {
            
                let newRow = formRow.copy() as! XLFormRowDescriptor
                newRow.tag = "secondAlert"
                newRow.title = "Second Alert"
                self.form.addFormRow(newRow, afterRow:formRow)
            }
            else if !oldValue.valueData().isEqual(0) && newValue.valueData().isEqual(0) {
                self.form.removeFormRowWithTag("secondAlert")
            }
        }
        else if formRow.tag == "all-day" {
            let startDateDescriptor = self.form.formRowWithTag("starts")!
            let endDateDescriptor = self.form.formRowWithTag("ends")!
            let dateStartCell: XLFormDateCell = startDateDescriptor.cellForFormController(self) as! XLFormDateCell
            let dateEndCell: XLFormDateCell = endDateDescriptor.cellForFormController(self) as! XLFormDateCell
            if formRow.value!.valueData() as? Bool == true {
                startDateDescriptor.valueTransformer = DateValueTrasformer.self
                endDateDescriptor.valueTransformer = DateValueTrasformer.self
                dateStartCell.formDatePickerMode = XLFormDateDatePickerMode.Date
                dateEndCell.formDatePickerMode = XLFormDateDatePickerMode.Date
            }
            else{
                startDateDescriptor.valueTransformer = DateTimeValueTrasformer.self
                endDateDescriptor.valueTransformer = DateTimeValueTrasformer.self
                dateStartCell.formDatePickerMode = XLFormDateDatePickerMode.DateTime
                dateEndCell.formDatePickerMode = XLFormDateDatePickerMode.DateTime
            }
            self.updateFormRow(startDateDescriptor)
            self.updateFormRow(endDateDescriptor)
        }
        else if formRow.tag == "starts" {
            let startDateDescriptor = self.form.formRowWithTag("starts")!
            let endDateDescriptor = self.form.formRowWithTag("ends")!
            let dateStartCell: XLFormDateCell = startDateDescriptor.cellForFormController(self) as! XLFormDateCell
            let dateEndCell: XLFormDateCell = endDateDescriptor.cellForFormController(self) as! XLFormDateCell
            if startDateDescriptor.value!.compare(endDateDescriptor.value as! NSDate) == NSComparisonResult.OrderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                endDateDescriptor.value = NSDate(timeInterval: 60*60*24, sinceDate: startDateDescriptor.value as! NSDate)
                endDateDescriptor.cellConfig.removeObjectForKey("detailTextLabel.attributedText")
                self.updateFormRow(endDateDescriptor)
            }
        }
        else if formRow.tag == "ends" {
            let startDateDescriptor = self.form.formRowWithTag("starts")!
            let endDateDescriptor = self.form.formRowWithTag("ends")!
            let dateEndCell = endDateDescriptor.cellForFormController(self) as! XLFormDateCell
            if startDateDescriptor.value!.compare(endDateDescriptor.value as! NSDate) == NSComparisonResult.OrderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                dateEndCell.update()
                let newDetailText : String =  dateEndCell.detailTextLabel!.text!
                let strikeThroughAttribute = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
                let strikeThroughText = NSAttributedString(string: newDetailText, attributes: strikeThroughAttribute)
                endDateDescriptor.cellConfig["detailTextLabel.attributedText"] = strikeThroughText
                self.updateFormRow(endDateDescriptor)
            }
            else{
                let endDateDescriptor = self.form.formRowWithTag("ends")!
                endDateDescriptor.cellConfig.removeObjectForKey("detailTextLabel.attributedText")
                self.updateFormRow(endDateDescriptor)
            }
        }
    }

    func cancelPressed(button: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
    }
}


class NativeEventNavigationViewController : UINavigationController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.tintColor = UIColor.redColor()
    }
    
}
