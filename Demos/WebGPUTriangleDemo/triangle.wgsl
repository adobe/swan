// Vertex shader - outputs position and color
struct VertexOutput {
    @builtin(position) position: vec4f,
    @location(0) color: vec4f,
};

@vertex
fn vertexMain(@builtin(vertex_index) vertexIndex: u32) -> VertexOutput {
    // Triangle vertices (position and color baked in)
    var positions = array<vec2f, 3>(
        vec2f( 0.0,  0.5),   // Top
        vec2f(-0.5, -0.5),   // Bottom left
        vec2f( 0.5, -0.5),   // Bottom right
    );

    var colors = array<vec4f, 3>(
        vec4f(1.0, 0.0, 0.0, 1.0),  // Red
        vec4f(0.0, 1.0, 0.0, 1.0),  // Green
        vec4f(0.0, 0.0, 1.0, 1.0),  // Blue
    );

    var output: VertexOutput;
    output.position = vec4f(positions[vertexIndex], 0.0, 1.0);
    output.color = colors[vertexIndex];
    return output;
}

@fragment
fn fragmentMain(input: VertexOutput) -> @location(0) vec4f {
    return input.color;
}

