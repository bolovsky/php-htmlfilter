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
     * List of valid html tags
     * @var array validHtmlTags
     */
    protected validHtmlTags = [
        "span", "div", "iframe", "p",
        "strong", "applet", "video",
        "noscript", "form", "button", "a",
        "del", "dd", "fieldset",
        "iframe", "ins", "li", "object",
        "td", "th", "abbr", "acronym", "address", "b", "bdo",
        "big", "caption", "cite", "code", "dfn", "dt",
        "em", "font", "h1", "h2", "h3", "h4", "h5",
        "h6", "i", "kbd", "label", "legend",
        "pre", "q", "rb", "rt", "s", "samp", "small",
        "span", "strike","sub", "sup", "tt",
        "u", "var", "blockquote", "map"
    ] {
        get, set
    };


    /**
     * Parses the provided text to obtain a list of htmlElements
     * @param string html
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
        
        return result;
    }

    /**
     * Verifies if the given string is a tag
     * @param string text
     *
     * @return boolean
     */
    protected function isTag(string! text) -> boolean
    {
        return strpos(text, "<") === 0 && strpos(text, ">") === (text->length() - 1);
    }

    /**
     * Verifies is a tag is in the whitelist of available tags
     * @param string tag
     *
     * @return boolean
     */
    protected function isTagValid(const string! tag) -> boolean
    {
        return in_array(strtolower(tag), this->validHtmlTags);
    }

    /**
     * returns the tagName
     * @param string fullTag
     *
     * @return string
     */
    protected function filterTagName(string! fullTag) -> string
    {
        let fullTag = trim(str_replace(["</","<",">"], "", fullTag));

        var split;
        let split = preg_split("/\s/",fullTag);

        return split[0];
    }
}