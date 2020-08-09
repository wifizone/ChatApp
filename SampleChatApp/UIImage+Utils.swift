//
//  UIImage+Utils.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 25.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

extension UIImage {

    // MARK: - UIImage+Resize
	func compressTo(expectedSizeInKb:Int) -> UIImage? {
		guard let data = self.compressedImageData(expectedSizeInKb: expectedSizeInKb) else { return nil }
		return UIImage(data: data)
	}

	func compressedImageData(expectedSizeInKb:Int) -> Data? {
		let sizeInBytes = expectedSizeInKb * 1024
		var needCompress: Bool = true
		var imgData: Data?
		var compressingValue: CGFloat = 1.0
		while (needCompress && compressingValue > 0.0) {
			if let data: Data = self.jpegData(compressionQuality: compressingValue) {
				if data.count < sizeInBytes {
					needCompress = false
					imgData = data
				} else {
					compressingValue -= 0.1
				}
			}
		}
		
		if let data = imgData {
			if (data.count < sizeInBytes) {
				return data
			}
		}
		return nil
	}
}
