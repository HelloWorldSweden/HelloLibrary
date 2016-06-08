
--[[--
	Den här modulen laddar alla HelloLibrary moduler. Användbart
	när du önskar använda många i samma script, så slipper du
	ladda in varje en efter en. Istället kan du bara ladda in
	denna modul som följande:
	
	require "HelloLibrary.Modules.ALL"
	
	Bara för att du laddar in alla moduler betyder det inte att du
	måste använda alla; det ger dig bara möjligheten att använda
	alla utan att du behöver tänka på om du glömt ladda in någon
	modul.
--]]--

require "HelloLibrary.Modules.Animation"
require "HelloLibrary.Modules.Health"
require "HelloLibrary.Modules.Math"
require "HelloLibrary.Modules.Movement"
require "HelloLibrary.Modules.Physics"
require "HelloLibrary.Modules.Utility"