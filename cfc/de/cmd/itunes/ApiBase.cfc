/**
*
* @file  cfc/de/cmd/itunes/ApiBase.cfc
* @author Christian Mueller  
* @description Small API Wrapper to call itunes information
* 
* for more information see: http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
*
*/

component output="false" displayname=""  {

    property string BASE_URL_SEARCH; // simple search
    property string STORE; // itunes needs store parameter, default: US
    property string MEDIA_TYPE; // one can query for different mediatypes, we only want music

    /**
    * Defined by the itunes API documentation one can query for different
    *   entities:
    *   musicArtist,musicTrack, album, musicVideo, mix, song
    * 
    *   attributes:
    *   mixTerm, genreIndex, artistTerm, composerTerm, albumTerm, ratingIndex, songTerm, musicTrackTerm
    * 
    *   limit:
    *   The number of search results you want the iTunes Store to return. Default is 50.
    * 
    *   lang:
    *   The language, English or Japanese, you want to use when returning search results. Specify the language using the five-letter codename. For example: en_us. The default is en_us (English).
    * 
    *   explicit:
    *   A flag indicating whether or not you want to include explicit content in your search results. The default is Yes.
    */

    public function init(){
        BASE_URL_SEARCH = "http://itunes.apple.com/search";
        STORE           = "US";
        MEDIA_TYPE      = "music";
        return this;
    }

    public string function test() {
        return testConnection("http://www.spotify.com").status_code;
    }

    // do a testconnection to any url you want
    public struct function testConnection(string targetUrl) {
        http url="#arguments.targetUrl#" method="HEAD" result="testCall" timeout="10" {
            httpparam type="Header" name="Accept" value="application/json";
        };
        return testCall;
    }

    /**
    * @private
    */
    private string function buildQueryString( required struct query) {
       var targetUrl  = BASE_URL_SEARCH;
        var queryLoop  = 0;
        var connect    = "";

        for (filter in arguments.query) {
            targetUrl = "#targetUrl##IIf( queryLoop gt 0, DE("&"), DE("?") )##filter#=#URLEncodedFormat(arguments.query[filter])#";
            queryLoop++;
        }

        return targetUrl;
    }

    /**
    * Dynamically build search query
    * 
    * @param query struct with search parameters
    */
    public struct function buildQuery(required struct query) {
        var targetUrl = this.buildQueryString( arguments.query );
        var result    = "";
        if( len( targetUrl ) ) {
            http url="#targetUrl#" method="GET" result="httpResult" {
                httpparam type="Header" name="Accept" value="application/json";
            };
            result               = deserializeJSON( httpResult.fileContent );
            result["requestUrl"] = targetUrl;
        }
        return result;
    }
}