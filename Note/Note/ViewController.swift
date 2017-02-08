//
//  ViewController.swift
//  Note
//
//  Created by Paul Young.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, CloudKitNoteDelegate {
	@IBOutlet var textView: UITextView?
	private var cloudKitNote = CloudKitNote()
	private var dirty = false
	private var saving = false
	private var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cloudKitNote.delegate = self
		cloudKitNote.load { (text, modified, error) in
			guard error == nil else {
				if let cknerror = error as? CloudKitNoteError? {
					if cknerror == .noteNotFound {
						return
					}
				}
				debugPrint("cloudKitNote.load failed, error: ", error!)
				return
			}
			DispatchQueue.main.async {
				self.textView!.text = text
			}
		}
		
		timer = Timer.scheduledTimer(timeInterval: 6.0,
		                             target: self,
		                             selector: #selector(onTimer),
		                             userInfo: nil,
		                             repeats: true)
	}
	@objc func onTimer() {
		if dirty && !saving {
			saving = true
			let textToSave = textView?.text
			let modifiedToSave = Date()
			self.cloudKitNote.save(text: textToSave!, modified: modifiedToSave) { error in
				DispatchQueue.main.async {
					self.saving = false
					guard error == nil else {
						debugPrint("cloudKitNote.save failed, error: ", error!)
						return
					}
					self.dirty = false
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textViewDidChange(_ textView: UITextView) {
		dirty = true
	}
	
	func cloudKitNoteChanged(note: CloudKitNote) {
		DispatchQueue.main.async {
			self.textView!.text = note.text
		}
	}
}
