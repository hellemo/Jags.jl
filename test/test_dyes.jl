using Jags
using Base.Test

old = pwd()
path = @windows ? "\\Examples\\Dyes" : "/Examples/Dyes"
ProjDir = Pkg.dir("Jags")*path
cd(ProjDir)
println("Moving to directory: $(ProjDir)")

for i in 0:8
  isfile("CODAchain$(i).txt") && rm("CODAchain$(i).txt")
  isfile("dyes-inits$(i).R") && rm("dyes-inits$(i).R")
end
isfile("CODAindex.txt") && rm("CODAindex.txt")
isfile("CODAindex0.txt") && rm("CODAindex0.txt")
isfile("CODAtable0.txt") && rm("CODAtable0.txt")
isfile("dyes-data.R") && rm("dyes-data.R")
isfile("dyes.bugs") && rm("dyes.bugs")
isfile("dyes.jags") && rm("dyes.jags")
isfile("jdyesautocormeanplot.svg") && rm("jdyesautocormeanplot.svg")
isfile("jdyessummaryplot.svg") && rm("jdyessummaryplot.svg")
isfile("jdyessummaryplot2.svg") && rm("jdyessummaryplot2.svg")

include(ProjDir*@windows ? "\\" : "/"*"jdyes.jl")

for i in 0:8
  isfile("CODAchain$(i).txt") && rm("CODAchain$(i).txt")
  isfile("dyes-inits$(i).R") && rm("dyes-inits$(i).R")
end
isfile("CODAindex.txt") && rm("CODAindex.txt")
isfile("CODAindex0.txt") && rm("CODAindex0.txt")
isfile("CODAtable0.txt") && rm("CODAtable0.txt")
isfile("dyes-data.R") && rm("dyes-data.R")
isfile("dyes.bugs") && rm("dyes.bugs")
isfile("dyes.jags") && rm("dyes.jags")
#isfile("jdyesautocormeanplot.svg") && rm("jdyesautocormeanplot.svg")
#isfile("jdyessummaryplot.svg") && rm("jdyessummaryplot.svg")
#isfile("jdyessummaryplot2.svg") && rm("jdyessummaryplot2.svg")

cd(old)
