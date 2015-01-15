namespace HtmlFilter;

/**
 * Class HtmlParser
 */
class HtmlParser
{
    /**
     * Holds the passed configuration
     * @var array tagDelimiters
     */
    protected tagDelimiters = ["<", "&lt;", ">", "&gt;"] {
        get, set
    };

    /**
     * Since zephir doesn't support pass by ref yet, need this in order to reduce the tags
     *
     * @var array tagsSet
     */
    protected tagsSet = [];

    /**
     * @var HtmlFilter\HtmlParser\Model\HtmlElement htmlElement
     */
    protected htmlElement{
        get, set
    };

    /**
     * Html Parser
     */
    public function __construct(htmlElement=null)
    {
        if !htmlElement {
            let this->htmlElement
                = new \HtmlFilter\HtmlParser\Model\HtmlElement();
        } else {
            let this->htmlElement = htmlElement;
        }

    }

    /**
     * Parses the provided text to obtain an array of htmlElements
     *
     * @param string html
     *
     * @return array
     */
    public function parse(string! html) -> array
    {
        var result = [];
        var raw = [];

        preg_match_all(
            "/<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+(?<!\s)>|(?:[^<]*)/m",
            html,
            raw
        );//"@fixme remove this, syntax highlight wrong

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
     * Validates and build the html
     *
     * @param string tagText
     *
     * @return \\HtmlFilter\HtmlParser\HtmlTag\HtmlTag
     */
    protected function buildTag(string! tagText)
    {
        if this->isTag(tagText) {
            var tag;
            var tagName;
            let tagName = this->filterTagName(tagText);

            //if an end tag gets here, it doesn't have a open tag and must be discarted
            if this->isEndTag(tagText) {
                return false;
            }

            let tag = new \HtmlFilter\HtmlParser\HtmlTag(tagName, this->htmlElement);

            tag->setAttributes(
                this->buildAttributes(tag->getTag(), tagText)
            );

            if this->getHtmlElement()->isEmptyElement(tagName) {
                return tag;
            }

            tag->setChildren(
                this->buildChildren(tag->getTag())
            );

            //to ensure no issue arise, discard all invalid/unrecognized html tags
            //this must be made at the end of parsing, to remove all inner elements
            if !this->getHtmlElement()->isTagValid(tagName) {
                return false;
            }

            return tag;

        } else {
            return new \HtmlFilter\HtmlParser\PlainText(tagText);
        }
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
                if (tag instanceof \HtmlFilter\HtmlParser\Model\HtmlElement)
                    && !this->getHtmlElement()->isElementNestable(tag->getTag()) {
                    continue;
                }

                let tmpTags[] = tag;
            }
        }

        return tmpTags;
    }

    /**
     * Builds the attributes for the htmlTag from the text directly
     *
     * @param string tagName
     * @param string fullTagWithAttributes
     *
     * @return array
     */
    protected function buildAttributes(string! tagName, string! fullTagWithAttributes) -> array
    {
        var attributes = [];
        var tmp = [];
        preg_match_all("/<\\s?" . tagName . " \\s?(.*)\\s?\\/?>/mi", fullTagWithAttributes, tmp);

        if !empty(tmp) && count(tmp[1]) > 0 {
            preg_match_all("/((([^=]+)=((?:\"|'))([^\"']+)\\4) ?)/m",tmp[1][0], tmp);
            let attributes = tmp[2];
        }

        return attributes;
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