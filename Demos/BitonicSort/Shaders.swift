// Copyright 2026 Adobe
// All Rights Reserved.
//
// NOTICE: Adobe permits you to use, modify, and distribute this file in
// accordance with the terms of the Adobe license agreement accompanying
// it.
//
// Ported from https://github.com/webgpu/webgpu-samples/tree/main/sample/bitonicSort

// Uniform data passed each step. Must match WGSL Uniforms struct below. 
struct Uniforms {
	let width: UInt32
	let height: UInt32
	let algorithmStep: UInt32
	let blockHeight: UInt32
    let highlight: UInt32  // 0 = grayscale, 1 = show comparison pairs

    static var wgslDefinition: String {
		// Could be generated with reflection, but this is simple enough.
        """
        struct Uniforms {
            width: u32,
            height: u32,
            algorithmStep: u32,
            blockHeight: u32,
            highlight: u32,
        }
        """
    }}

// WGSL shader code for BitonicSort demo

/// Generates compute shader for bitonic sort operations with the specified workgroup size.
/// The workgroup size determines the shared memory size (workgroupSize * 2) and affects
/// which operations can be done locally vs globally.
/// Handles all 4 step types: flip/disperse × local/global
func bitonicComputeShader(workgroupSize: Int) -> String {
	let sharedMemorySize = workgroupSize * 2
	return """
		\(Uniforms.wgslDefinition)

		// Workgroup shared memory for local operations
		// Size = workgroupSize * 2 (each invocation handles 2 elements)
		var<workgroup> local_data: array<u32, \(sharedMemorySize)>;

		@group(0) @binding(0) var<storage, read> input_data: array<u32>;
		@group(0) @binding(1) var<storage, read_write> output_data: array<u32>;
		@group(0) @binding(2) var<uniform> uniforms: Uniforms;

		// Compare and swap in local memory
		fn local_compare_and_swap(idx_before: u32, idx_after: u32) {
		    //idx_before should always be < idx_after
		    if (local_data[idx_after] < local_data[idx_before]) {
		        let temp = local_data[idx_before];
		        local_data[idx_before] = local_data[idx_after];
		        local_data[idx_after] = temp;
		    }
		}

		// Calculate flip indices for an invocation
		// Flip pairs elements symmetrically within a block
		fn get_flip_indices(invocation_id: u32, block_height: u32) -> vec2<u32> {
		  // Calculate index offset (i.e move indices into correct block)
		    let block_offset = ((2u * invocation_id) / block_height) * block_height;
		    let half_height = block_height / 2u;
		    let idx_in_block = invocation_id % half_height;
		    let low = idx_in_block + block_offset;
		    let high = block_height - idx_in_block - 1u + block_offset;
		    return vec2<u32>(low, high);
		}

		// Calculate disperse indices for an invocation
		// Disperse pairs adjacent halves within a block
		fn get_disperse_indices(invocation_id: u32, block_height: u32) -> vec2<u32> {
		    let block_offset = ((2u * invocation_id) / block_height) * block_height;
		    let half_height = block_height / 2u;
		    let idx_in_block = invocation_id % half_height;
		    let low = idx_in_block + block_offset;
		    let high = idx_in_block + half_height + block_offset;
		    return vec2<u32>(low, high);
		}

		// Compare and swap in global memory
		fn global_compare_and_swap(idx_before: u32, idx_after: u32) {
		    if (input_data[idx_after] < input_data[idx_before]) {
		        output_data[idx_before] = input_data[idx_after];
		        output_data[idx_after] = input_data[idx_before];
		    } else {
		        output_data[idx_before] = input_data[idx_before];
		        output_data[idx_after] = input_data[idx_after];
		    }
		}

		// Algorithm type constants
		const ALGO_LOCAL_FLIP: u32 = 1u;
		const ALGO_LOCAL_DISPERSE: u32 = 2u;
		const ALGO_GLOBAL_FLIP: u32 = 3u;
		const ALGO_GLOBAL_DISPERSE: u32 = 4u;

		@compute @workgroup_size(\(workgroupSize), 1, 1)
		fn computeMain(
		    @builtin(global_invocation_id) global_id: vec3<u32>,
		    @builtin(local_invocation_id) local_id: vec3<u32>,
		    @builtin(workgroup_id) workgroup_id: vec3<u32>
		) {
		    let total_elements = uniforms.width * uniforms.height;
		    let block_height = uniforms.blockHeight;

		    switch uniforms.algorithmStep {
		        // LOCAL FLIP: Load to shared memory, flip, write back
		        case ALGO_LOCAL_FLIP: {
		            // Load two elements per invocation into shared memory
		            let offset = workgroup_id.x * \(sharedMemorySize)u;
		            local_data[local_id.x * 2u] = input_data[offset + local_id.x * 2u];
		            local_data[local_id.x * 2u + 1u] = input_data[offset + local_id.x * 2u + 1u];

		            workgroupBarrier();

		            // Calculate indices and swap
		            let indices = get_flip_indices(local_id.x, block_height);
		            local_compare_and_swap(indices.x, indices.y);

		            workgroupBarrier();

		            // Write back to global memory
		            output_data[offset + local_id.x * 2u] = local_data[local_id.x * 2u];
		            output_data[offset + local_id.x * 2u + 1u] = local_data[local_id.x * 2u + 1u];
		        }

		        // LOCAL DISPERSE: Similar to flip but with disperse indices
		        case ALGO_LOCAL_DISPERSE: {
		            let offset = workgroup_id.x * \(sharedMemorySize)u;
		            local_data[local_id.x * 2u] = input_data[offset + local_id.x * 2u];
		            local_data[local_id.x * 2u + 1u] = input_data[offset + local_id.x * 2u + 1u];

		            workgroupBarrier();

		            let indices = get_disperse_indices(local_id.x, block_height);
		            local_compare_and_swap(indices.x, indices.y);

		            workgroupBarrier();

		            output_data[offset + local_id.x * 2u] = local_data[local_id.x * 2u];
		            output_data[offset + local_id.x * 2u + 1u] = local_data[local_id.x * 2u + 1u];
		        }

		        // GLOBAL FLIP: Work directly on global memory
		        case ALGO_GLOBAL_FLIP: {
		            let indices = get_flip_indices(global_id.x, block_height);
		            if (indices.y < total_elements) {
		                global_compare_and_swap(indices.x, indices.y);
		            }
		        }

		        // GLOBAL DISPERSE: Work directly on global memory
		        case ALGO_GLOBAL_DISPERSE: {
		            let indices = get_disperse_indices(global_id.x, block_height);
		            if (indices.y < total_elements) {
		                global_compare_and_swap(indices.x, indices.y);
		            }
		        }

		        default: {
		            // No-op for algorithmStep = 0
		        }
		    }
		}
		"""
}

/// Vertex shader: generates fullscreen triangle from vertex index
/// This is just a full-screen canvas on which to draw the sorted data.
let bitonicDisplayVertexShader = """
struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) uv: vec2<f32>,
}

@vertex
fn vertexMain(@builtin(vertex_index) vertexIndex: u32) -> VertexOutput {
    // Generate fullscreen triangle (3 vertices cover the screen)
    // Using the "fullscreen triangle" technique
    var output: VertexOutput;

    // Positions for fullscreen triangle
    let x = f32((vertexIndex & 1u) << 2u) - 1.0;  // -1, 3, -1
    let y = f32((vertexIndex & 2u) << 1u) - 1.0;  // -1, -1, 3

    output.position = vec4<f32>(x, y, 0.0, 1.0);
    output.uv = vec2<f32>(x * 0.5 + 0.5, 0.5 - y * 0.5);  // [0,1] range, Y flipped

    return output;
}
"""

/// Fragment shader: visualizes the sorting array as a grayscale grid
/// Supports highlight mode to show comparison pairs in red/green
// Ported from bitonicDisplay.frag.wgsl
let bitonicDisplayFragmentShader = """
\(Uniforms.wgslDefinition)

@group(0) @binding(0) var<storage, read> data: array<u32>;
@group(0) @binding(1) var<uniform> uniforms: Uniforms;

@fragment
fn fragmentMain(@location(0) uv: vec2<f32>) -> @location(0) vec4<f32> {
    let width = f32(uniforms.width);
    let height = f32(uniforms.height);

    // Map UV to grid cell
    let pixel = vec2<u32>(
        u32(uv.x * width),
        u32(uv.y * height)
    );

    // Calculate element index from grid position
    let elementIndex = pixel.y * uniforms.width + pixel.x;
    let totalElements = uniforms.width * uniforms.height;

    // Bounds check
    if (elementIndex >= totalElements) {
        return vec4<f32>(0.0, 0.0, 0.0, 1.0);
    }

    // Get element value and normalize to [0, 1]
    let value = f32(data[elementIndex]);
    let normalized = value / f32(totalElements);
    let intensity = 1.0 - normalized;

    // Highlight mode: show which elements are being compared
    if (uniforms.highlight == 1u && uniforms.blockHeight >= 2u) {
        // Check if element is in lower or upper half of its comparison block
        let inLowerHalf = (elementIndex % uniforms.blockHeight) < (uniforms.blockHeight / 2u);

        if (inLowerHalf) {
            // Lower half of block: RED (these compare with green elements)
            return vec4<f32>(intensity, 0.0, 0.0, 1.0);
        } else {
            // Upper half of block: GREEN (these compare with red elements)
            return vec4<f32>(0.0, intensity, 0.0, 1.0);
        }
    }

    // Default: grayscale (bright = small value, dark = large value)
    return vec4<f32>(intensity, intensity, intensity, 1.0);
}
"""