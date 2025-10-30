import Foundation
import SwiftFormat
import SwiftSyntax
import SwiftSyntaxBuilder

public struct Formatter {
	private let formatter: SwiftFormatter

	public init(config: Configuration? = nil) {
		self.formatter = SwiftFormatter(configuration: config ?? Configuration())
	}

	public func format<Output: TextOutputStream>(code: String, filename: String, output: inout Output) throws {
		try formatter.format(source: code, assumingFileURL: URL(fileURLWithPath: filename), selection: .infinite, to: &output)
	}
}
