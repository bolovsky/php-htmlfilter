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
     * @todo list is incomplete, quite a few tags missing
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
     * Since zephir doesn't support pass by ref yet, need this in order to reduce the tags
     *
     * @var array tagsSet
     */
    protected tagsSet = [];

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

        preg_match_all("/<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+(?<!\s)>|(?:[^<]*)/m", html, raw);//"@fixme remove this, syntax highlight wrong

        if is_array(raw) && isset(raw[0]) {
            let result = this->buildResult(raw[0]);
        }
        
        return result;
    }

    protected function buildResult(array tags) -> array
    {
        var text;
        let this->tagsSet = tags;
        var tmpTags = [];

        loop {
            if empty(this->tagsSet) {
                break;
            }

            let text = array_shift(this->tagsSet);

            if this->isTag(text) {
                var tag;
                let tag = new \Htmlfilter\Parser\HtmlTag(this->filterTagName(text));
                if tag->isEmptyElement() {
                    let tmpTags[] = tag;
                    continue;
                }

                tag->setChildren(
                    this->buildChildren(text)
                );

                let tmpTags[] = tag;
            } else {
                let tmpTags[] = new \Htmlfilter\Parser\PlainText(text);
            }
        }

        return tmpTags;
    }

    protected function buildChildren(string openTag="", array children=[]) -> array
    {
        var text;
        array tmpTags = [];

        for text in this->tagsSet {
            var tag;
            if this->isCorrespondentEndTag(text, openTag) {
                //return
            }

            if this->isTag(text) {
                let tag = new \Htmlfilter\Parser\HtmlTag(this->filterTagName(text));
            }
        }

        return tmpTags;
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

    /**
     * Check if the tag is of a correspondent value
     *
     * @param string tag
     * @param string tagName
     *
     * @return boolean
     */
    protected function isCorrespondentEndTag(string! tag, string! tagName) -> boolean
    {
        return !empty(preg_match("/^<\/\s?" . tagName . "\s?>$/i", tag));
    }
}