<cfset itunes = createObject("component", "cfc.de.cmd.itunes.ApiWrapper").init() />
<cfset results = "" />
<cfdump var="#itunes.searchArtist('fresh prince')#" label="searchArtist" />
