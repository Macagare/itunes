/**
*
* @file  cfc/de/cmd/itunes/ApiWrapper.cfc
* @author  Christian Mueller
* @description extends itunes ApiBase class
*
*/

component output="false" displayname="" extends="ApiBase"  {

    public function init(){
        SUPER.init();
        return this;
    }


    public any function searchArtist(string name) {
        return this.buildQuery( { "term":"#arguments.name#", "entity" : "musicArtist", "attributes" : "artistTerm", "limit" : 25 } );
    }
    
    

}