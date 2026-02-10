// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
import Foundation

// Local vs Global: When blockHeight ≤ workgroupSize×2, all comparisons fit in one workgroup's
// shared memory (fast). Otherwise, we use global memory (slower but necessary).
enum StepType : UInt32 {
	case none = 0
	case flipLocal = 1
	case disperseLocal = 2
	case flipGlobal = 3
	case disperseGlobal = 4
}

struct BitonicSortState {
	let totalElements: Int
	let workgroupSize: Int

	// The "span" of comparisons. In a flip with blockHeight=8, element 0 compares with element 7,
	// element 1 with 6, etc. Block height doubles after each complete flip+disperse cycle.
	private(set) var blockHeight: Int = 2

	// Tracks the outer loop. Each cycle starts with a flip at maxBlockHeight, then disperses
	// down to blockHeight=2.
	private(set) var maxBlockHeight: Int = 2

	private(set) var currentStep: Int = 0
	let totalSteps: Int

	var sortIsComplete: Bool {
		maxBlockHeight >= totalElements * 2
	}

	init(totalElements: Int, workgroupSize: Int) {
		self.totalElements = totalElements
		self.workgroupSize = workgroupSize

		// Total steps = (log2(n) * (log2(n) + 1)) / 2
		let log2n = Int(log2(Double(totalElements)))
		self.totalSteps = (log2n * (log2n + 1)) / 2
	}

	var currentStepType: StepType {
		if sortIsComplete { return .none }

		let isFlip = self.blockHeight == self.maxBlockHeight
		let isLocal = self.blockHeight <= self.workgroupSize * 2

		switch (isFlip, isLocal) {
		case (true, true): return .flipLocal
		case (true, false): return .flipGlobal
		case (false, true): return .disperseLocal
		case (false, false): return .disperseGlobal
		}
	}

	var workgroupsForCurrentStep: Int {
		// Each workgroup handles (workgroupSize * 2) elements for local ops
		// For global ops, each invocation handles 2 elements
		let elementsPerWorkgroup = self.workgroupSize * 2
		return (self.totalElements + elementsPerWorkgroup - 1) / elementsPerWorkgroup
	}

	mutating func advanceStep() {
		guard !sortIsComplete else { return }

		self.currentStep += 1
		// Each step halves the block height for disperse
		self.blockHeight /= 2

		// If block height gets down to 1, we've completed a cycle.
		// Double maxBlockHeight and start new cycle with flip
		if self.blockHeight < 2 {
			self.maxBlockHeight *= 2
			self.blockHeight = self.maxBlockHeight
		}
	}

	mutating func reset() {
		self.blockHeight = 2
		self.maxBlockHeight = 2
		self.currentStep = 0
	}
}
