"""
	ShotProfileLSEWEM(m,m0,d,[param])

Least squares shot profile wave equation migration of isotropic 3C data.

# Arguments
- `m::Array{AbstractString,1}`
- `m0::Array{AbstractString,1}`
- `d::Array{AbstractString,1}`
"""
function ShotProfileLSEWEM(m::Array{AbstractString,1},m0::Array{AbstractString,1},d::Array{AbstractString,1},param=Dict())


	cost = get(param,"cost","cost.txt")   # cost output text file
	precon = get(param,"precon",false)   # flag for preconditioning by smoothing the image
	wd = join(["tmp_LSM_wd_",string(int(rand()*100000))])
	CalculateSampling(d[1],wd,param)
	param["wd"] = wd
	param["tmute"] = 0.;
	param["vmute"] = 999999.;
	if (precon == true)
		param["operators"] = [ApplyDataWeights SeisMute ShotProfileEWEM SeisSmoothGathers]
	else
		param["operators"] = [ApplyDataWeights SeisMute ShotProfileEWEM]
	end
	ConjugateGradients(m,m0,d,cost,param)
	SeisRemove(wd)

end
