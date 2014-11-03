######### Jags line program example  ###########

using Compat, Mamba, Jags

old = pwd()
ProjDir = Pkg.dir("Jags", "Examples", "Line")
cd(ProjDir)

line = "
model {
  for (i in 1:n) {
        mu[i] <- alpha + beta*(x[i] - x.bar);
        y[i]   ~ dnorm(mu[i],tau);
  }
  x.bar   <- mean(x[]);
  alpha    ~ dnorm(0.0,1.0E-4);
  beta     ~ dnorm(0.0,1.0E-4);
  tau      ~ dgamma(1.0E-3,1.0E-3);
  sigma   <- 1.0/sqrt(tau);
}
"

data = @Compat.Dict(
  "x" => [1, 2, 3, 4, 5],
  "y" => [1, 3, 3, 3, 5],
  "n" => 5
)

inits = [
  @Compat.Dict("alpha" => 0,"beta" => 0,"tau" => 1),
  @Compat.Dict("alpha" => 1,"beta" => 2,"tau" => 1),
  @Compat.Dict("alpha" => 3,"beta" => 3,"tau" => 2),
  @Compat.Dict("alpha" => 5,"beta" => 2,"tau" => 5)
]

monitors = @Compat.Dict(
  "alpha" => true,
  "beta" => true,
  "tau" => true,
  "sigma" => true
  )

jagsmodel = Jagsmodel(name="line", model=line,
  data=data, init=inits, monitor=monitors,
  ncommands=3, nchains=2,
  #adapt=1000, update=10000,
  #thin=10,
  deviance=true, dic=true, popt=true,
  #updatedatafile=true, updateinitfiles=true,
  #pdir=ProjDir
  );

println("\nJagsmodel that will be used:")
jagsmodel |> display
println("Input observed data dictionary:")
data |> display
println("\nInput initial values dictionary:")
inits |> display
println()

sim = jags(jagsmodel, ProjDir)
describe(sim)
println()

## Brooks, Gelman and Rubin Convergence Diagnostic
try
  gelmandiag(sim1, mpsrf=true, transform=true) |> display
catch e
  #println(e)
  gelmandiag(sim, mpsrf=false, transform=true) |> display
end

## Geweke Convergence Diagnostic
gewekediag(sim) |> display

## Highest Posterior Density Intervals
hpd(sim) |> display

## Cross-Correlations
cor(sim) |> display

## Lag-Autocorrelations
autocor(sim) |> display

## Deviance Information Criterion
#dic(sim) |> display

## Plotting
p = plot(sim, [:trace, :mean, :density, :autocor], legend=true);
draw(p, ncol=4, filename="$(jagsmodel.name)-summaryplot", fmt=:svg)
draw(p, ncol=4, filename="$(jagsmodel.name)-summaryplot", fmt=:pdf)

# Below will only work on OSX, please adjust for your environment.
# JULIASVGBROWSER is set from environment variable JULIA_SVG_BROWSER
@osx ? if length(JULIASVGBROWSER) > 0
        for i in 1:4
          isfile("$(jagsmodel.name)-summaryplot-$(i).svg") &&
            run(`open -a $(JULIASVGBROWSER) "$(jagsmodel.name)-summaryplot-$(i).svg"`)
        end
      end : println()

# Below examples of using other ways to display the simulation results
(index, chains) = Jags.read_jagsfiles(jagsmodel)

println()
chains[1]["samples"] |> display
println()
if size(chains, 1) >= 4
  chains[4]["samples"] |> display
end


println()
if jagsmodel.dic
  (idx0, chain0) = Jags.read_pDfile(jagsmodel)
  #idx0 |> display
  println()
  chain0[1]["samples"] |> display
end

if jagsmodel.dic || jagsmodel.popt
  println()
  pDmeanAndpopt = Jags.read_table_file(jagsmodel, data["n"])
  pDmeanAndpopt |> display
end

cd(old)
