

--
-- In order to have Orochi compiled with CUDA, you need to define OROCHI_ENABLE_CUEW, and add the CUDA include path to your Orochi project.
--
-- If your project is using premake, this script can be included:
-- it helps to configure your Orochi project
--
--
--


function oropremake_joinPaths(basePath, additionalPath)
	-- Detect the path separator based on the operating system
	local pathSeparator = package.config:sub(1,1)
	-- Check if the basePath already ends with a path separator
	if basePath:sub(-1) ~= pathSeparator then
		basePath = basePath .. pathSeparator
	end
	return basePath .. additionalPath
end

function oropremake_PathOK(inPath)
	if ( inPath == nil or inPath == '' ) then
		return false
	end
	if ( os.isdir(inPath) ) then
		return true
	end
	return false
end




-- REGION GENERATED BY OROCHI SUMMONER
--REGION_PREMAKE_START CudaPath

best_cuda_version_name = "12.2"
best_cuda_envvar = "CUDA_PATH_V12_2"
best_cuda_path_linux = "/usr/local/cuda-12.2"
best_cuda_path_windows = "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v12.2"
backup_cuda_envvar = "CUDA_PATH"
backup_cuda_path_linux = "/usr/local/cuda"

--REGION_PREMAKE_END



--
-- first, try the best CUDA paths ( the one that matches the version use for this Orochi )
--

cuda_path = os.getenv(best_cuda_envvar)

-- if not found in envvar, try if path exist ( linux )
if (not oropremake_PathOK(cuda_path)) then
	if ( os.isdir(best_cuda_path_linux) ) then
		cuda_path = best_cuda_path_linux
	end
end

-- try the windows path
if (not oropremake_PathOK(cuda_path)) then
	if ( os.isdir(best_cuda_path_windows) ) then
		cuda_path = best_cuda_path_windows
	end
end

if (not oropremake_PathOK(cuda_path)) then
	print("The requiered version of CUDA for this Orochi is not found: " .. best_cuda_version_name .. ". It's advised that you install this version.")
end

--
-- If CUDA still not found, search the "backup" paths
--

if (not oropremake_PathOK(cuda_path)) then
	cuda_path = os.getenv(backup_cuda_envvar)
end

-- if the CUDA PATH is not in the env var, search in the classic folder
if (not oropremake_PathOK(cuda_path)) then
	if ( os.isdir(backup_cuda_path_linux) ) then
		cuda_path = backup_cuda_path_linux
	end
end

-- Enable CUEW if CUDA is forced or if we find the CUDA SDK folder
if ( _OPTIONS["forceCuda"] or   oropremake_PathOK(cuda_path)  ) then
	print("CUEW is enabled.")
	defines {"OROCHI_ENABLE_CUEW"}
end

-- If we find the CUDA SDK folder, add it to the include dir
if (not oropremake_PathOK(cuda_path)) then
	if _OPTIONS["forceCuda"] then
		print("WARNING: CUEW is enabled but it may not compile because CUDA SDK folder ( CUDA_PATH ) not found. You should install the CUDA SDK, or set CUDA_PATH.")
	else
		print("WARNING: CUEW is automatically disabled because CUDA SDK folder ( CUDA_PATH ) not found. You can force CUEW with the --forceCuda argument.")
	end
else
	print("CUDA SDK install folder found: " .. cuda_path)
	includedirs {  oropremake_joinPaths(cuda_path,"include") }
end


