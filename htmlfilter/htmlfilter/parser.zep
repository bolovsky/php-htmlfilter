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
            let result = this->buildResult(
                array_filter(raw[0])
            );
        }
        
        return result;
    }

    /**
     * Builds the base html array
     *
     * @param array tags
     *
     * @return array
     */
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

            var tag;
            let tag = this->buildTag(text);
            if tag {
                let tmpTags[] = tag;
            }
        }

        return tmpTags;
    }

    /**
     * Recursive method to build the html children
     *
     * @param string openTag
     *
     * @return array
     */
    protected function buildChildren(string openTag="") -> array
    {
        var text;
        var tmpTags = [];

        loop {
            if empty(this->tagsSet) {
                break;
            }

            let text = array_shift(this->tagsSet);
            if this->isCorrespondentEndTag(text, openTag) {
                return tmpTags;
            }

            var tag;
            let tag = this->buildTag(text);
            if tag {
                let tmpTags[] = tag;
            }
        }

        return tmpTags;
    }

    /**
     * Validates and build the html
     *
     * @param string tagText
     *
     * @return \Htmlfilter\Parser\HtmlTag
     */
    protected function buildTag(string! tagText)
    {
        if this->isTag(tagText) {
            var tag;
            var tagName;
            let tagName = this->filterTagName(tagText);
            //to ensure no issue arise, discard all invalid/unrecognized html tags
            if !this->isTagValid(tagName) || this->isEndTag(tagText) {
                return false;
            }

            let tag = new \Htmlfilter\Parser\HtmlTag(tagName);

            if tag->isEmptyElement() {
                return tag;
            }

            tag->setChildren(
                this->buildChildren(tag->getTag())
            );

            return tag;

        } else {
            return new \Htmlfilter\Parser\PlainText(tagText);
        }
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
        var remove = ["/","<",">"];
        var str;

        for str in remove {
            let fullTag = str_replace(str, "", fullTag);
        }

        let fullTag = trim(fullTag);

        var split;
        let split = preg_split("`\\s`",fullTag);

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
        return !empty(preg_match("/<\\/\\s?" . tagName . "\\s?>/is", tag));
    }

    /**
     * Verifies if is a end tag
     *
     * @param string tagName
     *
     * @return boolean
     */
    protected function isEndTag(string! tagName) -> boolean
    {
        return !empty(preg_match("/<\\/\\s?\\w*\\s?>/is", tagName));
    }
}