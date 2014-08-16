module Jags
  
  using DataArrays, DataFrames

  #### Includes ####
  
  include("jagsmodel.jl")
  include("jagscode.jl")
  include("fileutils.jl")
  
  #### Exports ####
  
  export
  
  # From jagsmodel.jl
    Jagsmodel,
    DictOrDictArray,
    
    # From jagscode.jl
    jags
  
  #### Deprecated ####
  
  include("deprecated.jl")

end # module
