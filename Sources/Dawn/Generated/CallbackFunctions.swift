public typealias GPUBufferMapCallback = (GPUMapAsyncStatus, String?) -> Void

public typealias GPUCompilationInfoCallback = (GPUCompilationInfoRequestStatus, GPUCompilationInfo) -> Void

public typealias GPUCreateComputePipelineAsyncCallback = (GPUCreatePipelineAsyncStatus, GPUComputePipeline?, String?) -> Void

public typealias GPUCreateRenderPipelineAsyncCallback = (GPUCreatePipelineAsyncStatus, GPURenderPipeline?, String?) -> Void

public typealias GPUDeviceLostCallback = (UnsafePointer<GPUDevice?>?, GPUDeviceLostReason, String?) -> Void

public typealias GPULoggingCallback = (GPULoggingType, String?) -> Void

public typealias GPUPopErrorScopeCallback = (GPUPopErrorScopeStatus, GPUErrorType, String?) -> Void

public typealias GPUQueueWorkDoneCallback = (GPUQueueWorkDoneStatus, String?) -> Void

public typealias GPURequestAdapterCallback = (GPURequestAdapterStatus, GPUAdapter?, String?) -> Void

public typealias GPURequestDeviceCallback = (GPURequestDeviceStatus, GPUDevice?, String?) -> Void

public typealias GPUUncapturedErrorCallback = (UnsafePointer<GPUDevice?>?, GPUErrorType, String?) -> Void
