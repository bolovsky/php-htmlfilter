namespace Htmlfilter;

class Parser
{
    /**
     * Holds the passed configuration
     * @var array tagDelimiters
     */
    protected tagDelimiters = ["<", "&lt;", ">", "&gt;"] {
        get, set
    };

    /**
     * Holds the html elements that are considered empty
     * @var array emptyElements
     */
    protected emptyElements = [
        "area": 1, "br": 1, "col": 1,
        "embed": 1, "hr": 1, "img": 1,
        "input": 1, "isindex": 1, "param": 1
    ] {
        get, set
    };

    /**
     * @param string text
     *
     * @return array
     */
    public function parse(string! html) -> array
    {
        var result = [];
        var raw = [];

        preg_match_all("/<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+(?<!\s)>|(?:[^<]*)/m", html, raw);

        if is_array(raw) && isset(raw[0]) {
            let result = raw[0];
        }
        
        return array_filter(result);
    }
}